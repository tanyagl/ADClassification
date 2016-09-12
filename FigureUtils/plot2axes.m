function [ax, h] = plot2axes(varargin)

%PLOT2AXES Graphs one set of data with two sets of axes
%
%   PLOT2AXES(X, Y, 'Param1', 'Value1', ...) plots X versus Y with
%   secondary axes.  The following parameters are accepted [default
%   values]:
%
%     xloc ['top']: location of secondary X-axis
%     yloc ['right']: location of secondary Y-axis
%     xscale [1]: scaling factor for secondary X-axis (scalar)
%     yscale [1]: scaling factor for secondary Y-axis (scalar)
%
%           xscale and yscale can also be an anonymous function that
%           describes the relationship between the 2 axes, such as the
%           equation relating Celsius and Fahrenheit: @(x) 5/9*(x-32)
%
%     xlim [NaN NaN] : xlim in the primary axes (secondary is adjusted
%                      accordingly). The default is naturally selected by
%                      the plotting function.
%     ylim [NaN NaN] : ylim in the primary axes (secondary is adjusted
%                      accordingly). The default is naturally selected by
%                      the plotting function.
%
%   PLOT2AXES(@FUN, ...) uses the plotting function @FUN instead of PLOT to
%   produce the plot.  @FUN should be a function handle to a plotting
%   function, e.g. @plot, @semilogx, @semilogy, @loglog ,@stem, etc. that
%   accepts the syntax H = FUN(...).  Optional arguments accepted by these
%   plotting functions are also allowed (e.g. PLOT2AXES(X, Y, 'r*', ...))
%
%   [AX, H] = PLOT2AXES(...) returns the handles of the primary and
%   secondary axes (in that order) in AX, and the handles of the graphic
%   objects in H.
%
%   Right-click on the axes to bring up a context menu for adding grids to
%   the axes.
%
%   The actual data is plotted in the primary axes.  The primary axes lie
%   on top of the secondary axes.  After the execution of this function,
%   the primary axes become the current axes.  If the next plot replaces
%   the axes, the secondary axes are automatically deleted.
%
%   When you zoom and pan, the secondary axes will automatically adjust
%   itself (only available on R2006b or later). For older releases of
%   MATLAB, there will be a "Fix Axes" menu, which let's you adjust the
%   limits.
%
%   PLOT2AXES('FixAxes') fixes the secondary limits of all figures created
%   using plot2axes.
%
%   Example 1:
%     x = 0:.1:1;
%     y = x.^2 + 0.1*randn(size(x));
%     [ax, h] = plot2axes(x, y, 'ro', 'yscale', 25.4);
%     title('Length vs Time');
%     ylabel(ax(1), 'inch');
%     ylabel(ax(2), 'millimeter');
%     xlabel('time (sec)');
%
%   Example 2:
%     x = 1:10;
%     y = 50*rand(size(x));
%     [ax, h] = plot2axes(x, y, 'ro', 'yscale', @(x) 5/9*(x-32), ...
%         'xscale', 2.20);
%     xlabel(ax(1), 'kg'); ylabel(ax(1), 'Fahrenheit');
%     xlabel(ax(2), 'lb'); ylabel(ax(2), 'Celcius');
%
% See also PLOTYY, function_handle.

% VERSIONS:
%   v1.0 - first version.
%   v1.1 - added option to specify X and Y limits.
%   v1.2 - remove tick labels for secondary axes if no scaling factors are
%          specified. Also, fixed bug in matching the scaling type (linear
%          or log).
%   v1.3 - added the 'Fix Axes' menu for adjusting the secondary axes
%          limits after zooming.
%   v1.4 - added the option for specifying an equation for xscale and
%          yscale. (June 2005)
%   v1.5 - fixed problem plotting on uipanel, where the parent of the axes
%          is not a figure. (Feb 2006)
%   v2.0 - added auto adjust of axes limits (works R2006b and later). now
%          works with nonlinear scaling. added ability to add grids
%          interactively. use of function handles instead of strings.
%          (Dec 2009)
%
% Copyright 2009 The MathWorks, Inc.

if nargin < 1
  error('Not enough input arguments');
end

if nargin == 1 && strcmpi(varargin{1}, 'FixAxes')
  figsH = findobj('Type', 'figure');
  if ~isempty(figsH)
    for iFig = 1:length(figsH)
      fixAxes(figsH(iFig));
    end
  end
  return;
end

% Default options
opts.xloc = 'top';
opts.yloc = 'right';
opts.xscale = 1;
opts.yscale = 1;
opts.xlim = [NaN NaN];
opts.ylim = [NaN NaN];

var = varargin;

% Check to see if the first argument is a function handle
if isa(var{1}, 'function_handle');
  func   = var{1};
  var(1) = '';
else
  func = @plot;
end

% Parse optional arguments
idx = 1;
while idx <= length(var)
  param = var{idx};
  
  % Optional parameters must be CHARS
  if ~ischar(param)
    idx = idx + 1;
    continue;
  end
  
  param = lower(param);
  
  % Process only if it's one of the parameters
  if ~ismember(param, {'xloc','yloc','xscale','yscale','xlim','ylim'})
    idx = idx + 1;
    continue;
  end
  
  % Make sure that there is a corresponding value
  if length(var) <= idx
    error('plot2axes:InvalidParamValuePair', ...
      'Optional parameters must come in param-value pairs');
  end
  
  % Validate the values
  val = var{idx+1};
  switch param
    case 'xloc'
      if ~ischar(val) || ~ismember(lower(val), {'top', 'bottom'})
        myerror(upper(param));
      end
      opts.xloc = lower(val);
      
    case 'yloc'
      if ~ischar(val) || ~ismember(lower(val), {'left', 'right'})
        myerror(upper(param)');
      end
      opts.yloc = lower(val);
      
    case {'xscale', 'yscale'}
      if (~isnumeric(val) && ~isa(val, 'function_handle')) || ...
          numel(val) > 1
        myerror(upper(param));
      end
      opts.(param) = val;
      
    case {'xlim', 'ylim'}
      if ~isnumeric(val) || ~isequal(size(val), [1 2])
        myerror(upper(param));
      end
      opts.(param) = val;
      
  end
  
  % Remove the arguments from the list
  var(idx:idx+1) = '';
  
end

% Determine the axes to plot
ax1 = newplot;
nextplot = get(ax1, 'NextPlot');

figH = gcf;

% Plot data
h = feval(func, var{:});

set(ax1, 'Box', 'off', 'Color', 'none');

% Create secondary axes on top of primary axes
ax2 = axes(...
  'Box'     , 'off', ...
  'Parent'  , get(ax1, 'Parent'), ...
  'Hittest', 'off');

% Link the Position property
hl = linkprop([ax1 ax2], 'Position');
set(ax1, 'UserData', hl);

opts.ax1 = ax1;
opts.ax2 = ax2;

% Create context menu for grid control
hMenu = uicontextmenu('Callback', @contextMenuCallback);
uimenu('Parent', hMenu, 'Label', 'Left Grid', ...
  'Callback', @contextMenuCallback);
uimenu('Parent', hMenu, 'Label', 'Right Grid', ...
  'Callback', @contextMenuCallback);
uimenu('Parent', hMenu, 'Label', 'Bottom Grid', ...
  'Callback', @contextMenuCallback);
uimenu('Parent', hMenu, 'Label', 'Top Grid', ...
  'Callback', @contextMenuCallback);

set([ax1, ax2], 'UIContextMenu', hMenu);

%--------------------------------------------------------------------------
% Apply options - scaling is done in "fixAxes" subfunction
%--------------------------------------------------------------------------
if strcmpi(opts.xloc, 'top') % xloc
  set(ax1, 'XAxisLocation', 'bottom');
  set(ax2, 'XAxisLocation', 'top');
else
  set(ax1, 'XAxisLocation', 'top');
  set(ax2, 'XAxisLocation', 'bottom');
end

if strcmpi(opts.yloc, 'right') % yloc
  set(ax1, 'YAxisLocation', 'left');
  set(ax2, 'YAxisLocation', 'right');
else
  set(ax1, 'YAxisLocation', 'right');
  set(ax2, 'YAxisLocation', 'left');
end

if ~all(isnan(opts.xlim))  % xlim
  set(ax1, 'xlim', opts.xlim);
end
if ~all(isnan(opts.ylim))  % ylim
  set(ax1, 'ylim', opts.ylim);
end

set(ax2, 'xscale', get(ax1, 'xscale'), ...
  'yscale', get(ax1, 'yscale'));

%--------------------------------------------------------------------------
% Create DeleteProxy objects (an invisible text object) so that the other
% axes will be deleted properly.  <inspired by PLOTYY>
%--------------------------------------------------------------------------
DeleteProxy(1) = text(...
  'Parent'          , ax1, ...
  'Visible'         , 'off', ...
  'HandleVisibility', 'off');
DeleteProxy(2) = text(...
  'Parent'          , ax2, ...
  'Visible'         , 'off', ...
  'HandleVisibility', 'off', ...
  'UserData'        , DeleteProxy(1));
set(DeleteProxy(1), ...
  'UserData'        , DeleteProxy(2));

set(DeleteProxy, ...
  'DeleteFcn'       , @DelFcn);

%--------------------------------------------------------------------------
% Switch the order of axes, so that the secondary axes are under the
% primary axes, and that the primary axes become the current axes.
%--------------------------------------------------------------------------
% get list of figure children. ax1 and ax2 must exist in this list
ch = get(get(ax1, 'Parent'), 'Children');
i1 = find(ch == ax1);       % find where ax1 is
i2 = find(ch == ax2);       % find where ax2 is
ch([i1, i2]) = [ax2; ax1];  % swap ax1 and ax2

% assign the new list of children and set current axes to primary
set(get(ax1, 'Parent'), 'Children', ch);
set(figH, 'CurrentAxes', ax1);

% Restore NextPlot property (just in case it was modified)
set([ax1, ax2], 'NextPlot', nextplot);

setappdata(ax1, 'p2a', opts);

fixAxes(figH, struct('Axes', ax1));

try
  % Try setting Action Callbacks for zoom and pan
  % (only available in R2006b or later)
  hz = zoom;
  hp = pan;
  set(hz, 'ActionPostCallback', @fixAxes);
  set(hp, 'ActionPostCallback', @fixAxes);
  
catch %#ok<CTCH>
  % It must be an older release of MATLAB (pre-R2006b)
  
  % Create 'Fix Axes' button for adjusting the secondary axes limits after
  % zooming
  hMenu = findobj(figH, 'Type', 'uimenu', 'Label', 'Fix Axes');
  if strcmpi(get(figH, 'Menubar'), 'figure') && ...
      (isempty(hMenu) || ~ishandle(hMenu))
    hMenu = uimenu('Parent', figH, 'Label', 'Fix Axes');
    uimenu('Parent', hMenu, 'Label', 'Fix Axes Limits', ...
      'Callback', @fixAxes);
  end
  zoom off;
  pan off;
  
end

if nargout
  ax = [ax1, ax2];
end


function DelFcn(obj, edata) %#ok<INUSD>
%--------------------------------------------------------------------------
% DelFcn - automatically delete both axes
%--------------------------------------------------------------------------

try %#ok<TRYNC>
  set(get(obj, 'UserData'), ...
    'DeleteFcn', 'try;delete(get(gcbo, ''UserData''));end');
  set(obj, 'UserData', ...
    get(get(obj, 'UserData'), 'Parent'));
  delete(get(obj,'UserData'));
end


function fixAxes(obj, edata)
%--------------------------------------------------------------------------
% fixAxes - fix the scaling of the axes
%--------------------------------------------------------------------------

% This is only for pre-R2006b (called from a menu)
if strcmp(get(obj, 'type'), 'uimenu')
  fixAxes(ancestor(obj, 'figure'));
  return;
end

if nargin == 1
  axs = findobj(obj, 'type', 'axes');
  for iAx = 1:length(axs)
    fixAxes(obj, struct('Axes', axs(iAx)));
  end
  
else
  
  opts = getappdata(edata.Axes, 'p2a');
  
  if ~isempty(opts)
    if ishandle(opts.ax1) && ishandle(opts.ax2)
      if isa(opts.xscale, 'function_handle')
        fh = opts.xscale;
        if islinearANDincreasing(fh, xlim(opts.ax1))
          set(opts.ax2, 'XLim', fh(xlim(opts.ax1)));
          set(opts.ax2, 'XTickLabelMode', 'auto');
          set(opts.ax2, 'XTickMode', 'auto');
        else
          set(opts.ax2, 'xlim', xlim(opts.ax1));
          set(opts.ax2, 'XTick', get(opts.ax1, 'XTick'));
          set(opts.ax2, 'XTickLabel', num2str(fh(get(opts.ax1, 'XTick'))',3));
        end
      else
        xlim(opts.ax2, opts.xscale * xlim(opts.ax1));
        if opts.xscale == 1
          set(opts.ax2, 'XTickLabel', '');
        end
      end
      if isa(opts.yscale, 'function_handle')
        fh = opts.yscale;
        if islinearANDincreasing(fh, ylim(opts.ax1))
          set(opts.ax2, 'YLim', fh(ylim(opts.ax1)));
          set(opts.ax2, 'YTickLabelMode', 'auto');
          set(opts.ax2, 'YTickMode', 'auto');
        else
          set(opts.ax2, 'YLim', ylim(opts.ax1));
          set(opts.ax2, 'YTick', get(opts.ax1, 'YTick'));
          set(opts.ax2, 'YTickLabel', num2str(fh(get(opts.ax1, 'YTick'))',3));
        end
      else
        ylim(opts.ax2, opts.yscale * ylim(opts.ax1));
        if opts.yscale == 1
          set(opts.ax2, 'YTickLabel', '');
        end
      end
    end
  end
end


function x = islinearANDincreasing(fcn,lims)
%--------------------------------------------------------------------------
% islinearANDincreasing - checks to see if FUN is a linear and increasing
%                         function
%--------------------------------------------------------------------------

% Create linearly spaced vector
vals = linspace(lims(1), lims(2), 20);

% Evaluate using "fun"
newvals = fcn(vals);

% Get the differences between values
delta = diff(newvals);

% Check to see if they are increasing
if ~all(delta>0)
  x = false;
  return;
end

delta_mean = mean(delta);
delta_stdev = std(delta);

% If all differences are the "same" (within 3 standard deviations), we will
% assume that they are equally spaced
x = all(delta < delta_mean+3*delta_stdev & delta > delta_mean-3*delta_stdev);


function contextMenuCallback(hObject, edata) %#ok<INUSD>
%--------------------------------------------------------------------------
% contextMenuCallback - manage grid display
%--------------------------------------------------------------------------

opts = getappdata(gca, 'p2a');

% If this is the top level context menu, update the checks based on whether
% the grid is on or not. This makes sure that if the grid was turned on
% programmatically, the check marks would accurately represent the state of
% the grids.
if strcmp(get(hObject, 'Type'), 'uicontextmenu')
  lgridMenu = findobj(hObject, 'Label', 'Left Grid');
  rgridMenu = findobj(hObject, 'Label', 'Right Grid');
  bgridMenu = findobj(hObject, 'Label', 'Bottom Grid');
  tgridMenu = findobj(hObject, 'Label', 'Top Grid');
  if strcmpi(opts.yloc, 'right')
    [lAx, rAx] = deal(opts.ax1, opts.ax2);
  else
    [lAx, rAx] = deal(opts.ax2, opts.ax1);
  end
  if strcmpi(opts.xloc, 'top')
    [bAx, tAx] = deal(opts.ax1, opts.ax2);
  else
    [bAx, tAx] = deal(opts.ax2, opts.ax1);
  end
  
  % Store in the UserData which axes and grid to turn on/off
  if strcmpi(get(lAx, 'YGrid'), 'on')
    set(lgridMenu, 'Checked', 'on');
    set(lgridMenu, 'UserData', {lAx, 'ygrid', 'off'});
  else
    set(lgridMenu, 'Checked', 'off');
    set(lgridMenu, 'UserData', {lAx, 'ygrid', 'on'});
  end
  if strcmpi(get(rAx, 'YGrid'), 'on')
    set(rgridMenu, 'Checked', 'on');
    set(rgridMenu, 'UserData', {rAx, 'ygrid', 'off'});
  else
    set(rgridMenu, 'Checked', 'off');
    set(rgridMenu, 'UserData', {rAx, 'ygrid', 'on'});
  end
  if strcmpi(get(bAx, 'XGrid'), 'on')
    set(bgridMenu, 'Checked', 'on');
    set(bgridMenu, 'UserData', {bAx, 'xgrid', 'off'});
  else
    set(bgridMenu, 'Checked', 'off');
    set(bgridMenu, 'UserData', {bAx, 'xgrid', 'on'});
  end
  if strcmpi(get(tAx, 'XGrid'), 'on')
    set(tgridMenu, 'Checked', 'on');
    set(tgridMenu, 'UserData', {tAx, 'xgrid', 'off'});
  else
    set(tgridMenu, 'Checked', 'off');
    set(tgridMenu, 'UserData', {tAx, 'xgrid', 'on'});
  end
  
else
  % The UserData contains all the necessary information to perform the
  % appropriate action.
  ud = get(hObject, 'UserData');
  % ud{1} - axes handle
  % ud{2} - xgrid/ygrid
  % ud{3} - on/off
  
  set(hObject, 'Checked', ud{3});
  set(ud{1}, ud{2}, ud{3});
  
end

function myerror(param)

error('plot2axes:InvalidParameterValue', ...
  'Invalid value for parameter %s', param);