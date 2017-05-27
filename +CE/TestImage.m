classdef TestImage < handle
    %TestImage help you test the performance of image enhancement algorithms.
    %Example
    % Test = CE.TestImage('pout.tif');         % specify datasets
    % Test.Method = {@imadjust, @imsharpen};   % specify methods to evaluate
    % Test.Metric = {@psnr, @ssim};	           % specify evaluate metrics
    % Test,                                    % run test and show result
    % save(Test);                              % save results

    properties
        Method = {}
        Metric = {}
        MethodCache = {}
        MetricCache = {}
        OutName = '<file>__<algo>.PNG';
        OutDir = '<data>/out'; % output result images
        
        %append = true; % append result if true, overwrite result if false.
        
        %tbl
        Report % = CE.TestReport([])
        Files
        DataDir % dataset folder
        
        LoadRaw = @(f)im2double(imread(f)) % filename
        LoadRes = @(f)im2double(imread(f))
        LoadRef = @(f)im2double(imread(f)) % preprocessing file when evaluating
    end
    
    properties (Constant)
        ReportFile = '<data>/out/TestReport.csv';
        CellStr = @(cellFun)cellfun(@char, cellFun, 'UniformOutput', false);
        CellFun = @(cellStr)cellfun(@str2func, cellStr, 'UniformOutput', false);
    end
    
    methods(Access = public)
        function this = addMethod(this, varargin), this.Method = this.CellFun( union(this.CellStr(this.Method), this.CellStr(varargin))); end%this.Method = [this.Method; varargin']; end
        function this = addMetric(this, varargin), this.Metric = this.CellFun( union(this.CellStr(this.Metric), this.CellStr(varargin))); end%this.Metric = [this.Metric; varargin']; end
        function this = delMethod(this, varargin), this.Method = this.CellFun( setdiff(this.CellStr(this.Method), this.CellStr(varargin))); end
        function this = delMetric(this, varargin), this.Metric = this.CellFun( setdiff(this.CellStr(this.Metric), this.CellStr(varargin))); end
        
        function delResult(this, varargin)
            outDir = strrep(this.OutDir, '<data>', this.DataDir);
            for n = 1:numel(varargin)
                outName = strrep(this.OutName, '<file>',  '*');
                outName = strrep(outName,      '<ext>',   '*');
                outName = strrep(outName,      '<algo>',  char(varargin{n}));
                eachfile([outDir filesep outName], @delete);
            end
        end
    end
    
    methods
        function this = TestImage(images, varargin)
            this.Files = eachfile(images);
            if isempty(this.Files)
                error 'no file found in this dataset.'
            else
                this.DataDir = fileparts(this.Files{1}); % images
            end
            
            % load configuation
            for n = 1:2:numel(varargin)-1
                this.(varargin{n}) = varargin{n+1};
            end
            
            % load cached
            reportFile = strrep(this.ReportFile, '<data>', this.DataDir);
            if exist(reportFile, 'file'), this.load(reportFile); end
        end
        
        function this = load(this, file)
            import CE.TestReport
            
            fprintf('<strong>Loading... %s </strong>\n', file);
            this.Report = TestReport(file);
            disp '<strong>Done Loading.</strong>'
            
            this.MethodCache = this.CellFun(this.Report.Method);
            this.MetricCache = this.CellFun(this.Report.Metric);
            this.Method = this.MethodCache;
            this.Metric = this.MetricCache;
        end
        
        function save(this, file)
            if nargin < 2
                file = strrep(this.ReportFile, '<data>', this.DataDir);
                if exist(file, 'file') % backup
                    movefile(file, rename(file, '<path>/<name>__%s.<ext>', datestr(now,'yyyy-mm-dd_HH-MM-SS.FFF')));
                end
            end
            writetable(this.Report.Data, file);
        end
        
        function report = runtest(this, methods, metrics)
            % here methods and metrics are cell string
            import CE.TestReport
            outDir = strrep(this.OutDir, '<data>', this.DataDir);
            if ~isdir(outDir), mkdir(outDir); end
            
            reportFile = strrep([this.ReportFile  '__tmp.txt'], '<data>', this.DataDir); % tempfile
            %if ~isdir(fileparts(reportFile)), mkdir(fileparts(reportFile)); end
            
            fid = fopen(reportFile, 'w');
            fprintf(fid, 'File\tMethod\t%s\n', strjoin(metrics, '\t')); % heading
            
            fprintf('<strong>Testing %s </strong>\n', this.DataDir);
            eachfile(this.Files, @onSingleFile);
            fprintf('<strong>Done Testing %s </strong>\n', this.DataDir);
            
            fclose(fid);
            fprintf('Benchmark Result see: %s\n', reportFile);
            report = TestReport(readtable(reportFile, 'Delimiter','\t'));
            
            function onSingleFile(inFile)
                %this.rawFile = inFile;
                %globalVar('Test_fileName', inFileName);
                 % heading
                fprintf('Method\t\t\t'); fprintf('%9s\t', metrics{:}); fprintf('\n');
                
                for m = methods(:)', method = m{1};
                    [~, name, ext] = fileparts(inFile);
                    outName = strrep(this.OutName, '<file>',  name);
                    outName = strrep(outName,      '<ext>',   ext(2:end));
                    outName = strrep(outName,      '<algo>',  char(method));
                    outFile = [outDir filesep outName];
                    
                    % regenerate results if it is not exist
                    if ~exist(outFile, 'file')
                        fprintf('Regenerate file: %s\n', outFile);
                        func = str2func(method);
                        res = func(this.LoadRaw(inFile));
                        imwrite(im2double(res), outFile);
                    end
                    
                    % load result file and compute metrics
                    ref = this.LoadRef(inFile);
                    res = this.LoadRes(outFile);
                    
                    globalVar('Test_resultFile', outFile);
                    
                    fprintf(fid, '%s\t%s', [name, ext], method); fprintf('%8s\t', method);
                    
                    for n = metrics(:)', metric = n{1}; % if eval exist, then do it
                        func = str2func(metric);
                        try % allow two or one input
                            marks = func(res, ref);
                        catch ME
                            switch ME.identifier
                                case {'MATLAB:TooManyInputs', 'MATLAB:narginchk:tooManyInputs'}
                                    marks = func(res);
                                otherwise
                                    ME.identifier, rethrow(ME)
                            end
                        end 
                        fprintf(fid, '\t%f', marks); fprintf('\t\t%.2f', marks);
                    end
                    fprintf(fid, '\n'); fprintf('\n');
                end
            end
        end
        
        function disp(this)
            method = this.CellStr(this.Method);
            metric = this.CellStr(this.Metric);
            methodCache = this.CellStr(this.MethodCache);
            metricCache = this.CellStr(this.MetricCache);
            
            if isempty(this.Report)
                this.Report = this.runtest(method, metric);
            else
                [oldMethod,indexMethodCache] = intersect(methodCache, method);
                [oldMetric,indexMetricCache] = intersect(metricCache, metric);
                newMethod = setdiff(method, methodCache);
                newMetric = setdiff(metric, metricCache);
                
                this.Report = this.Report(indexMethodCache', indexMetricCache');
                if ~isempty(newMethod)
                    this.Report = vertcat(this.Report, this.runtest(newMethod, oldMetric)); end
                if ~isempty(newMetric)
                    this.Report = horzcat(this.Report,this.runtest([oldMethod, newMethod], newMetric)); end
            end
            
            this.MethodCache = this.Method;
            this.MetricCache = this.Metric;
            
            fprintf('<strong>Test Report: %s </strong>\n', this.DataDir);
            disp(this.Report);
        end
    end
    methods (Access = private)
        
    end
end

