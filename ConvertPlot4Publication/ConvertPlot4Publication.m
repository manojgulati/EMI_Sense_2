function ConvertPlot4Publication(filename, varargin)
%ConvertPlot4Publication - This function formats figures and outputs files for a publication
%
%This function formats a figure in a way that they are ready for a
%publication, i.e. width and height of the figure, textsize, textfont, alignment of
%subplots and backcolor and finally saves this figure in various formats (such as
% MATLAB .fig, PDF, EPS, PNG, or PSFrag). 
%
%You can use this function to save all your figures which you might later
%want to use for a publications. This way all your plots will be readily
%available in different output formats and consistent formatting.
%
% Syntax:  ConvertPlot4Publication(filename,varargin)
%
% Inputs:
%    filename (Required) - A string containting the name of the output files.
%    OPTIONS (Optional) - additional options are added in 'key' and 'value'
%                       pairs
%    Key           |   Value
%    ----------------------------------------------------------------------
%    'figure'      | Figure to create the files from.
%                  | default is gcf (current figure handle)
%    'height'      | Height of final figure in inch. If no value is given
%                  | the current figure width is taken.
%    'width'       | Width of final figure in inch. Default is 3.45in
%				   |(IEEE journal column width).
%    'backcolor'   | [none] - Changes the backcolor of the figure. Default is
%				   | none.
%    'samexaxes'   | [on, off] - Defines if in case of stacked subplots
%                  | only the x-axis from the lowest subplot is taken. Default is off.
%                  |  default is gcf (current figure handle)
%    'tickdir'     | [in, out] - Direction of ticks.
%    'box'         | [on, off] - Box around each plot is switched on or
%                  | off.
%    'fontname'    | Fontname used for each text element. Default value is 'Times New Roman'.
%    'fontsize'    | Fontsize of each text element, including axis and legends. Default value is 10.
%    'linewidth'   | Linewidth of each line. Default is 1.
%    'keepheights' | [on, off] - Do not change axes heights (default: off)
%    'keepvertical'| [on, off] - Do not rearange vertical position of the axes.	(default: off)
%    'pdf'         | [on, off] - PDF output (default: on)
%    'png'         | [on, off] - PNG output (default: on)
%    'eps'         | [on, off] - EPS output (default: on)
%    'psfrag'      | [on, off] - Psfrag output (default: off)
%    'fig'         | [on, off] - MATLAB .fig output (default: on)
%
% Outputs:
%    none 
%
% Example: 
% 
%       %Generate some data
%       y1 = randn(1000,1);
%       y2 = randn(1000,1);
%       
%       %Plot using two subplots
%       figure
%       subplot(2,1,1)
%       plot(y1)
%       ylabel('Y1')
%       subplot(2,1,2)
%       plot(y2)
%       ylabel('Y2')
%       xlabel('X')
%
%       %Export using the default options (output
%       ConvertPlot4Publication('testPlot')
% 
%       %Export again, this time changing the font and using the same x-axis
%       ConvertPlot4Publication('testPlot2', 'fontsize', 8, 'fontname', 'Arial', 'samexaxes', 'on', 'eps', 'off')
%
%
% Other m-files required: matlabfrag.m, export_fig.m (from matlabcentral)
% Subfunctions: none
% MAT-files required: none
%
% Version History:
%
% 12-Mar-2012   Updated ConvertPlot4Publications to support axes grids created with subplot.
% 19-Mar-2012   Fixed a bug introduced during the last update which would
%               reverse the vertical order of subplots (thanks to Jeff Parker
%               for pointing this out). Changed the default figure background to
%               white. Also updated the included export_fig toolbox to the latest version.


% Author: Christoph Brueser, Tobias Wartzek
% Chair of Medical Information Technology
% email: brueser@hia.rwth-aachen.de, wartzek@hia.rwth-aachen.de
% Oct 2010; Last revision: 12-Mar-2012

%------------- BEGIN CODE --------------

    %% Parse Argumente
    p = inputParser;
    p.addRequired('filename', @ischar);
    p.addOptional('figure', gcf, @ishandle);
    p.addOptional('height', 4, @isnumeric);
    p.addOptional('width', 0, @isnumeric);
    p.addOptional('backcolor', 'w', @(x)(ischar(x) || (isnumeric(x) && length(x) == 3)));
    p.addOptional('samexaxes', 'off', @(x)(strcmpi(x,'on') || strcmpi(x,'off')));
    p.addOptional('tickdir', 'in', @(x)(strcmpi(x,'in') || strcmpi(x,'out')));
    p.addOptional('box', 'on', @(x)(strcmpi(x,'on') || strcmpi(x,'off')));
    p.addOptional('fontsize', 10, @isnumeric);
    p.addOptional('fontname', 'Times New Roman', @ischar);
    p.addOptional('linewidth', 0.6, @isnumeric);
    p.addOptional('psfrag', 'off', @(x)(strcmpi(x,'on') || strcmpi(x,'off')));
    p.addOptional('eps', 'on', @(x)(strcmpi(x,'on') || strcmpi(x,'off')));
    p.addOptional('pdf', 'on', @(x)(strcmpi(x,'on') || strcmpi(x,'off')));
    p.addOptional('png', 'on', @(x)(strcmpi(x,'on') || strcmpi(x,'off')));
    p.addOptional('fig', 'on', @(x)(strcmpi(x,'on') || strcmpi(x,'off')));
    p.addOptional('keepheights', 'off', @(x)(strcmpi(x,'on') || strcmpi(x,'off')));
    p.addOptional('keepvertical', 'off', @(x)(strcmpi(x,'on') || strcmpi(x,'off')));
    p.parse(filename, varargin{:});
    params = p.Results;
   

	%% Adjust figure sizes
	H = params.figure;

    set(H, 'Visible', 'off')
	set(H, 'WindowStyle','normal')	% otherwise script doesn't work with docked figures
    
	set(H, 'Color', params.backcolor);
 	set(H, 'Units', 'inch');
	pos = get(H, 'Position');
    
    heightWidthRatio = pos(4)/pos(3);
    
    % Use default width if nothing else is specified
    if params.width == 0
        pos(3) = 3.45;				% (Standard: 3.45) Select the width of the figure in [in] 
    else
        pos(3) = params.width;
    end
    
    % If height is not explicitly given, maintain aspect ratio
    if params.height == 0
        pos(4) = heightWidthRatio * pos(3);
    else
        pos(4) = params.height;
    end
	
	set(H, 'Position', pos);
 	set(H, 'PaperType', 'a4letter');
	

	%% Find all axes objects to adjust the font
	h = findobj(H, 'Type', 'axes');
    
    set(h,'FontSize',params.fontsize)
	set(h,'FontName',params.fontname)
    
    %Remove legend objects for further processing
    h(strcmp(get(h, 'Tag'), 'legend')) = [];
    
    %Sort axes according to their appearance (top->bottom)
    pos = get(h, 'Position');
    if iscell(pos)
        posMat = cell2mat(pos);
        [~, idx] = sort(posMat(:,2),1,'descend');
        h = h(idx);
    end
    
    %% Set box und tickdir properties
    set(h, 'Tickdir', params.tickdir);
    set(h, 'Box', params.box);
    
    %% Set line width
    set(findobj(h, '-property', 'LineWidth', '-and', '-not', 'Type', 'axes'), 'LineWidth', params.linewidth);
            
    %% Set fonts for all figure children
	htext = findall(H, '-property', 'FontName');
    set(htext, 'FontName', params.fontname);
    set(htext, 'FontSize', params.fontsize);
    
    %% Adjust axes positions to optimally use the available space
    set(H, 'Units', 'points');
    set(h, 'Units', 'points');

    %Define margins
    if isempty(get(get(h(1), 'Title'), 'String'))
        top_margin = 1*params.fontsize;
    else
        top_margin = 2*params.fontsize;
    end
    bottom_margin = 3.5*params.fontsize;
    if strcmpi(params.samexaxes, 'on')
        axes_margin = 1.5*params.fontsize;
    else
        axes_margin = 4*params.fontsize;
    end
    right_margin = 2*params.fontsize;

    %Check for subplot grid arrangements
    grid = getappdata(H, 'SubplotGrid');
    if isempty(grid)
        grid = h;
    else
        grid = flipud(grid);
    end
    
    [num_vert, num_horz] = size(grid);
    
    fpos = get(H, 'Position');
    
    %Check if the vertical proportions should be kept intact
    if strcmpi(params.keepvertical, 'off')

        fbottom = 0;

        %Determine axes heights
        tmp = get(grid(:,1), 'Position');
        if iscell(tmp)
            tmp = [tmp{:}];
        end
        currHeights = tmp(4:4:end);

        %Compute new heights to maintain ratios
        if strcmpi(params.keepheights, 'off')
            currHeights = ones(1,num_vert);
        end
        newHeights = currHeights/sum(currHeights) * (fpos(4) - bottom_margin - top_margin - (num_vert-1)*axes_margin);

        %Adjust axes heights
        for l = 1:num_vert
            for k = 1:num_horz
                apos = get(grid(l,k), 'Position');
                apos(2) = fbottom + bottom_margin + (num_vert-l)*axes_margin;
                if l < num_vert
                    apos(2) = apos(2) + sum(newHeights(l+1:end));
                end
                apos(4) = newHeights(l);
                set(grid(l,k), 'Position', apos);
            end

            if l ~= 1
                titles = get(grid(l,:),'Title');
                if iscell(titles)
                    titles = cell2mat(titles);
                end
                set(titles,'String','');
            end

            if strcmpi(params.samexaxes, 'on') && l ~= num_vert
                set(grid(l,:), 'XTickLabel', []);
                xlabels = get(grid(l,:),'XLabel');
                if iscell(xlabels)
                    xlabels = cell2mat(xlabels);
                end
                set(xlabels,'String','');
            end
        end
    end
    
    set(H, 'Units', 'inch');
    set(h, 'Units', 'normalized');
    
    %% Adjust labels 
    
    %For each column separately
    for k = 1:num_horz
        if iscell(get(grid(:,k),'XLabel'))
            hxlabel=cell2mat(get(grid(:,k),'XLabel'));
            hylabel=cell2mat(get(grid(:,k),'YLabel'));
        else
            hxlabel=get(grid(:,k),'XLabel');
            hylabel=get(grid(:,k),'YLabel');
        end

        set(hylabel, 'VerticalAlignment', 'baseline');

        set(grid(:,k), 'Units', 'points');
        set(hylabel, 'Units', 'points')
        set(hxlabel, 'Units', 'points')

        ypos = get(hylabel, 'Position');
        xpos = get(hxlabel, 'Position');
        parentPos = get(grid(:,k), 'Position');

        if iscell(ypos)
            xposMat = cell2mat(xpos);
            yposMat = cell2mat(ypos);
            parentPosMat = cell2mat(parentPos);
        else
            xposMat = xpos;
            yposMat = ypos;
            parentPosMat = parentPos;
        end

        %Adjust X labels
        xposMat(:,2) = -2*params.fontsize;

        for l = 1:size(xposMat,1)
            set(hxlabel(l), 'Position', xposMat(l,:));
        end

        %Adjust Y labels
        d = min(yposMat(:,1))-0.3*params.fontsize;
        yposMat(:,1) = d;

        for l = 1:size(yposMat,1)
            set(hylabel(l), 'Position', yposMat(l,:));
        end

        set(hylabel, 'Units', 'normalized')
        set(hxlabel, 'Units', 'normalized')

        %Adjust axes positions to maintain label visibility
        parentPosMat(:,1) = (k-1)/num_horz*fpos(3) + 1.5*params.fontsize - d;
        parentPosMat(:,3) = fpos(3)/num_horz - right_margin - params.fontsize + d;
        for l = 1:size(yposMat,1)
            set(grid(l,k), 'Position', parentPosMat(l,:));
        end
        
        set(grid(:,k), 'Units', 'normalized');
    end
   
    
    
	    
    %% Center figure
    centerfig(H);
    set(H, 'Visible', 'on')
    
	%% Export figure
    snapnow    
	
	if strcmpi(params.fig, 'on')
        saveas(H,[params.filename '.fig'])
	end
    
    if strcmpi(params.pdf, 'on') 
        export_fig(params.filename, '-pdf')
    end
    
    if strcmpi(params.eps, 'on') 
        export_fig(params.filename, '-eps')
    end
    
    if strcmpi(params.png, 'on') 
        export_fig(params.filename, '-png', '-m2')
    end
 	
    if strcmpi(params.psfrag, 'on')
        matlabfrag(params.filename)
        fix_lines([params.filename '.eps'])
    end
	
	
	

	