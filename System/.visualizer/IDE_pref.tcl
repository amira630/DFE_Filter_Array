set Perspective_Version   2
#
pref::section perspective
set perspective_Name       {IDE_pref}
set perspective_DateTime   {2025-11-22T20:56:36}
set perspective_Directory  {D:/Mustafa/Projects/Digital_Design/Si_Clash_N/Design/DFE_Filter_Array/System}
set perspective_USER       {Mustafa}
set perspective_VisId      {2021.1}
#
pref::section preference
pref::set -type int -category General -name BinarySeparatorSpacing -value 0 -hide -description {Binary numbers will contain underscores every N digits} -label {Bin "_" Separator Spacing}
pref::set -type int -category General -name DecimalSeparatorSpacing -value 0 -hide -description {Decimal numbers will contain underscores every N digits} -label {Dec "_" Separator Spacing}
pref::set -type int -category General -name HexadecimalSeparatorSpacing -value 0 -hide -description {Hexadecimal numbers will contain underscores every N digits} -label {Hex "_" Separator Spacing}
pref::set -type int -category General -name OctalSeparatorSpacing -value 0 -hide -description {Octal numbers will contain underscores every N digits} -label {Oct "_" Separator Spacing}
pref::set -type bool -category General -name FilterPackages -value true -hide -description {The design window will not display instances defined in a package} -label {Design Window - Filter Out Packages}
pref::set -type bool -category General -name FilterCells -value true -hide -description {The design window will not display cell instances} -label {Design Window - Filter Out Cells}
pref::set -type bool -category General -name Upf -value true -hide -description {The design window will not display UPF objects} -label {Design Window - Filter out UPF}
pref::set -type bool -category General -name AutoReloadOnFault -value 0 -hide -description {If the tool should recieve a fatal signal, this preference indicates whether it should attmept to automatically restart.} -label {Automatically restart if a signal fault occurs}
pref::set -type bool -category General -name DisplayConstraintVariables -value true -hide -description {This preference indicates whether to display constraint_mode and rand_mode variables or not.} -label {Show rand_mode and constraint_mode fields}
pref::set -type bool -category General -name ImmResponseInFilter -value true -hide -description {The filter result is responded immediately to the input.} -label {Immediate response in Filter}
pref::set -type bool -category General -name ListVarDeclOrder -value true -hide -description {Variables will be listed in delcaration order if true} -label {List Variable in Declaration Order}
pref::set -type int -category General -name GutterIconSize -value 30 -description { Gutter Icon Size } -label { Gutter Icon Size }
pref::set -type int -category General -name GutterSize -value 35 -description { Gutter Size } -label { Gutter Size }
pref::set -type int -category General -name GutterPadding -value 7 -description { Gutter Icon Padding } -label { Gutter Icon Padding }
pref::set -type string -category General -name IDEVisibleWindows -value Lint###zinlintMsgDashboardView,zinlintDesignMetricsView,source,source,zinlintMsgStatusHistoryView,transcript,zinlintDesignInfoView,zincdcdutview,zinlintMsgSummaryView,zinmsgviewer,zinlintMsgView,zindetails,zinflownavigator -hide -description none -label none
pref::set -type bool -category General -name schSelectOnRMB -value false -hide -description none -label none
pref::set -type category -value Startup -hide
pref::set -type bool -category {Source Browser} -name EnableValueAnnotation -value true -hide -description {Displays signal values below their names if true} -label {Enable Value Annotation}
pref::set -type bool -category {Source Browser} -name EnableValueTooltip -value true -hide -description {Tooltips containing signal values will appear if the mouse hovers over a signal name} -label {Enable Value Tooltip}
pref::set -type bool -category {Source Browser} -name EnableExecutionTrace -value false -hide -description {Enable Execution Trace} -label {Enable Execution Trace}
pref::set -type bool -category {Source Browser} -name EnableMacroDebug -value true -hide -description {When true the user can expand lines containing macros so the code and values within can be examined} -label {Enable expansion of macro source for debugging}
pref::set -type bool -category {Source Browser} -name EnableTooltipReminder -value true -hide -description {Remind users that value tooltips must be enabled.} -label {Value tooltip reminder}
pref::set -type bool -category {Source Browser} -name zin_IDE_annotations -value true -hide -description none -label none
pref::set -type category -value Design -hide
pref::set -type category -value Default -hide
pref::set -type category -value Variable -hide
pref::set -type category -value Waveform -hide
pref::set -type category -value Schematic -hide
pref::set -type category -value {Signal Clipboard} -hide
pref::set -type category -value {Event Order} -hide
pref::set -type category -value {Browse Menu} -hide
pref::set -type category -value FSM -hide
pref::set -type category -value {Driver Receiver} -hide
pref::set -type category -value Files -hide
pref::set -type category -value {Search Design} -hide
pref::set -type category -value {Search Files} -hide
pref::set -type category -value {Trace X/Val} -hide
pref::set -type category -value {UVM Testbench} -hide
pref::set -type category -value Breakpoints -hide
pref::set -type category -value CallStack -hide
pref::set -type category -value Classes -hide
pref::set -type category -value {Class Instance} -hide
pref::set -type category -value Locals -hide
pref::set -type category -value {Memory Usage} -hide
pref::set -type category -value Sequence -hide
pref::set -type category -value Threads -hide
pref::set -type category -value {UVM Configuration} -hide
pref::set -type category -value {UVM Factory} -hide
pref::set -type category -value Watch -hide
pref::set -type category -value ATV -hide
pref::set -type category -value LiveSim -hide
pref::set -type category -value {Message Viewer} -hide
pref::set -type category -value MSNet -hide
pref::set -type category -value CDC
pref::set -type category -value {CDC.Domain Colors}
pref::set -type category -value {CDC.Domain Colors.User Defined}
pref::set -type category -value {CDC.Domain Colors.Predefined}
pref::set -type category -value Lint -hide
pref::set -type string -category Lint -name msgViewHiddenColumns -value , -hide -description none -label none
pref::set -type string -category Lint -name msgViewDefaultGrouping -value {} -hide -description none -label none
pref::set -type string -category Lint -name msgViewDefaultOrderWidth -value Severity:250,Type:250,Phase:185,Message:3036,Comment:100,Status:211,Owner:100,Reviewer:100,File:100,Line:100 -hide -description none -label none
pref::set -type string -category Lint -name compileMsgViewHiddenColumns -value {} -hide -description none -label none
pref::set -type string -category Lint -name compileMsgViewDefaultColumnGrouping -value {} -hide -description none -label none
pref::set -type string -category Lint -name compileMsgViewColumnOrderWidth -value {} -hide -description none -label none
pref::set -type bool -category Lint -name directivesEditorGroup -value false -hide -description none -label none
pref::set -type string -category Lint -name paDetailviewHiddenColumns -value {} -hide -description none -label none
pref::set -type string -category Lint -name paDetailviewDefaultGrouping -value {} -hide -description none -label none
pref::set -type string -category Lint -name paDetailviewDefaultOrderWidth -value {} -hide -description none -label none
pref::set -type string -category Lint -name paCellDetailHiddenColumns -value {} -hide -description none -label none
pref::set -type string -category Lint -name paCellDetailDefaultGrouping -value {} -hide -description none -label none
pref::set -type string -category Lint -name lintMessagesHiddenColumns -value {Design Category,Comment,Reviewer} -hide -description none -label none
pref::set -type string -category Lint -name lintMessagesDefaultGrouping -value {} -hide -description none -label none
pref::set -type string -category Lint -name lintMessagesviewDefaultOrderWidth -value Severity:127,Status:60,Check:250,Alias:100,Message:500,Module:150,Category:150,State:100,Owner:100,STARC*Reference:100 -hide -description none -label none
pref::set -type string -category Lint -name lintMessagesviewToolButtonFilters -value Pending,Uninspected,Bug -hide -description none -label none
pref::set -type string -category Lint -name lintMessagesviewToolButtonFiltersTuple -value Status!-!Equals!-!pending!@!Status!-!Equals!-!uninspected!@!Status!-!Equals!-!bug -hide -description none -label none
pref::set -type string -category Lint -name lintMessagesviewDialogFilters -value {} -hide -description none -label none
pref::set -type string -category Lint -name lintMessagesviewPythonFilterStr -value {lintToolButtonStatusFilter!-!((df["Status"].str.contains("^(?s:pending)$", case=True)) | (df["Status"].str.contains("^(?s:uninspected)$", case=True)) | (df["Status"].str.contains("^(?s:bug)$", case=True)))} -hide -description none -label none
pref::set -type string -category Lint -name lintMessagesviewDialogFiltersEnabledState -value {} -hide -description none -label none
pref::set -type string -category Lint -name lintMsgStatusHistoryviewHiddenColumns -value {} -hide -description none -label none
pref::set -type string -category Lint -name lintMsgStatusHistoryviewDefaultGrouping -value {} -hide -description none -label none
pref::set -type string -category Lint -name lintMsgStatusHistoryviewDefaultOrderWidth -value {} -hide -description none -label none
pref::set -type category -value LINT -hide
Perspective_Complete
