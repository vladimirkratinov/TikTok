# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'

target 'TikTok' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  pod 'FirebaseAnalytics'
  pod 'FirebaseAuth'
  pod 'FirebaseFirestore'
  pod 'FirebaseStorage'
  pod 'FirebaseCrashlytics'
  pod 'FirebaseDatabase'

  pod 'Appirater'
  pod 'SDWebImage'

end

# Fix Xcode 14 warnings like:
# warning: Run script build phase '[CP] Copy XCFrameworks' will be run during every build because it does not specify any outputs. To address this warning, either add output dependencies to the script phase, or configure it to run in every build by unchecking "Based on dependency analysis" in the script phase. (in target 'ATargetNameHere' from project 'YourProjectName')
# Ref.: https://github.com/CocoaPods/CocoaPods/issues/11444
def set_run_script_to_always_run_when_no_input_or_output_files_exist(project:)
  project.targets.each do |target|
    run_script_build_phases = target.build_phases.filter { |phase| phase.is_a?(Xcodeproj::Project::Object::PBXShellScriptBuildPhase) }
    cocoapods_run_script_build_phases = run_script_build_phases.filter { |phase| phase.name.start_with?("[CP]") }
    cocoapods_run_script_build_phases.each do |run_script|
      next unless (run_script.input_paths || []).empty? && (run_script.output_paths || []).empty?
      run_script.always_out_of_date = "1"
    end
  end
  project.save
end

post_integrate do |installer|
  main_project = installer.aggregate_targets[0].user_project
  set_run_script_to_always_run_when_no_input_or_output_files_exist(project: main_project)
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    # Projects usually do stuff in here…
  end
  set_run_script_to_always_run_when_no_input_or_output_files_exist(project: installer.pods_project)
end

