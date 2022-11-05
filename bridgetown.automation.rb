run "bundle show bridgetown-quick-search || bundle add bridgetown-quick-search -g bridgetown_plugins"
run "bundle show nokogiri || bundle add nokogiri"
run "yarn add @shoelace-style/shoelace @konnorr/bridgetown-quick-search @hotwired/stimulus @hotwired/turbo"
run "mkdir -p src/shoelace-assets && cp -r node_modules/@shoelace-style/shoelace/dist/assets src/shoelace-assets"

require 'fileutils'
require 'shellwords'
require 'rake'

# *** Set up remote repo pull

# Dynamically determined due to having to load from the tempdir
@current_dir = File.expand_path(__dir__)

# If its a remote file, the branch is appended to the end, so go up a level
ROOT_PATH = if __FILE__ =~ %r{\Ahttps?://}
              File.expand_path('../', __dir__)
            else
              File.expand_path(__dir__)
            end

DIR_NAME = File.basename(ROOT_PATH)

GITHUB_PATH = "https://github.com/konnorrogers/#{DIR_NAME}.git"

# Copied from: https://github.com/mattbrictson/rails-template
# Add this template directory to source_paths so that Thor actions like
# copy_file and template resolve against our source files. If this file was
# invoked remotely via HTTP, that means the files are not present locally.
# In that case, use `git clone` to download them to a local temporary dir.
def add_template_repository_to_source_path
  if __FILE__ =~ %r{\Ahttps?://}
    require 'tmpdir'

    source_paths.unshift(tempdir = Dir.mktmpdir(DIR_NAME + '-'))
    at_exit { FileUtils.remove_entry(tempdir) }
    run("git clone --quiet #{GITHUB_PATH.shellescape} #{tempdir.shellescape}")

    if (branch = __FILE__[%r{#{DIR_NAME}/(.+)/bridgetown.automation.rb}, 1])
      Dir.chdir(tempdir) { system("git checkout #{branch}") }
      @current_dir = File.expand_path(tempdir)
    end
  else
    source_paths.unshift(DIR_NAME)
  end
end

def strip_template_prefix(file)
  file.to_s.gsub(/^#{@current_dir}\/templates\//, "")
end

if yes? "The DoxxingTime installer can update styles, layouts, and page templates to use the new theme. You'll have the option to type 'a' to overwrite all existing files or 'd' to inspect each change. Would you like to proceed? (Y/N)"
  add_template_repository_to_source_path

  FileList.new("#{@current_dir}/templates/**/*.*").each do |file|
    target = strip_template_prefix(file)
    copy_file(file, target)
  end
end

say_status :doxxing_time, "Theme installation complete! Enjoy your fresh new design :)"
