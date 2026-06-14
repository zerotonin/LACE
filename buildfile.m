% ╔══════════════════════════════════════════════════════════════════╗
% ║  LACE — buildfile                                                 ║
% ║  « one build description for local dev and CI alike »             ║
% ╠══════════════════════════════════════════════════════════════════╣
% ║  MATLAB build tool (R2022b+).  Run locally with `buildtool`       ║
% ║  or in CI via matlab-actions/run-build.  Tasks:                   ║
% ║    check   - static code analysis (codeIssues)                    ║
% ║    test    - run the unit-test suite under tests/                 ║
% ║    toolbox - package LACE.mltbx into release/                     ║
% ╚══════════════════════════════════════════════════════════════════╝

function plan = buildfile
% Build plan for the LACE toolbox.  See banner above for tasks.
plan = buildplan(localfunctions);

% Static analysis over the whole source tree.
plan("check") = matlab.buildtool.tasks.CodeIssuesTask( ...
    ".", WarningThreshold = Inf, ErrorThreshold = 0);

% Unit tests (the tests/ folder is the home for future test classes).
plan("test") = matlab.buildtool.tasks.TestTask( ...
    "tests", SourceFiles = ".", ...
    TestResults = "test-results/results.xml", ...
    CodeCoverageResults = "code-coverage/coverage.xml");

% Package a redistributable toolbox; depends on a clean check.
plan("toolbox").Dependencies = "check";

plan.DefaultTasks = ["check" "test"];
end


function toolboxTask(~)
% Package the toolbox into release/LACE.mltbx using ToolboxOptions
% (R2023b+), so no GUI-authored .prj file is needed.
identifier = "a7c1e3b0-1f5e-4d2a-9c7b-0e5f1a2b3c4d";   % stable UUID
opts = matlab.addons.toolbox.ToolboxOptions(pwd, identifier);
opts.ToolboxName      = "LACE";
opts.ToolboxVersion   = "1.0.0";
opts.Description      = "Limbless Animal traCkEr - marker-free pose estimator.";
opts.AuthorName       = "Bart R. H. Geurten";
opts.AuthorCompany    = "University of Otago, Department of Zoology";
opts.MinimumMatlabRelease = "R2021a";
opts.ToolboxImageFile = fullfile("GUI", "snLogo.jpg");
opts.OutputFile       = fullfile("release", "LACE.mltbx");

if ~isfolder("release")
    mkdir("release");
end
matlab.addons.toolbox.packageToolbox(opts);
fprintf("Packaged %s\n", opts.OutputFile);
end
