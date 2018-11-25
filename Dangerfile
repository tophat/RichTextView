# Folder structure check
if not git.added_files.empty?
  message 'Please ensure that your new files respect the existing folder structure'
end

# Warn when there is a big PR
if git.lines_of_code > 500
	warn 'Big PR, please split up. Alternatively mark as a risky change.'
end

# Swiftlint
swiftlint.lint_files fail_on_error: true

# XCode Test Coverage
xcov.report(
   scheme: 'RichTextView',
   workspace: './RichTextView.xcworkspace',
   minimum_coverage_percentage: 80.0,
   output_directory: '',
   exclude_targets: 'Down.framework,
   FBSnapshotTestCase.framework,
   Nimble.framework,
   Nimble_Snapshots.framework,
   Quick.framework,
   SnapKit.framework',
)

message("
If anything other than `RichTextView` appears in the code coverage section please add it
to the `exclude_targets` property of the `xcov.report()` function in the Dangerfile
")
