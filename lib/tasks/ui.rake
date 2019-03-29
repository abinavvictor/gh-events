require 'open3'

class UILibrary

  # ------------------------------
  # Accessors

  attr_reader :project_path
  attr_reader :ui_library_path

  # ------------------------------
  # Initializer

  def initialize(project_root)
    @project_path = valid_path(project_root)
    @ui_library_path = valid_path(project_path + 'ui-library')
  end

  # ------------------------------
  # Public methods

  def check_scss!
    if system('which sass-lint > /dev/null 2>&1')
      puts "Checking SCSS style:\n  #{sass_lint_cmd}\n\n"
      output, status = Open3.capture2e(sass_lint_cmd)
      (warn(output); raise) unless status == 0
    else
      puts 'sass-lint not found in $PATH; skipping style checks'
    end
  end

  def compile_css!
    raise 'Can’t process SCSS without sass or sassc' unless sass_cmd
    puts "Processing source files from #{ui_library_path}"
    puts "                  to target #{stylesheets_path}\n\n"
    Dir.glob("#{scss_path}/*.scss").each do |infile|
      in_basename = File.basename(infile)
      next if in_basename.starts_with?('_')
      outfile = infile.sub(scss_path.to_s, stylesheets_path.to_s).sub(/.scss$/, '.css')
      puts "  Compiling #{relative_path(infile)} to #{relative_path(outfile)}"
      output, status = Open3.capture2e("#{sass_cmd} '#{infile}' > '#{outfile}'")
      (warn(output); raise) unless status == 0
    end
  end

  private

  # ------------------------------
  # Lazy fields

  def scss_path
    @scss_path ||= ui_library_path + 'scss'
  end

  def public_path
    @public_path ||= (project_path + 'public')
  end

  def stylesheets_path
    @stylesheets_path ||= begin
      stylesheets_path = public_path + 'stylesheets'
      stylesheets_path.mkpath
      stylesheets_path
    end
  end

  def sass_cmd
    @sass_cmd ||= if system('which sassc > /dev/null 2>&1')
      'sassc -t expanded'
    elsif system('which sass > /dev/null 2>&1')
      'sass'
    end
  end

  def sass_lint_cmd
    @sass_lint_cmd ||= begin
      ui_library_path_relative = relative_path(ui_library_path)
      cmd = <<~LINT
        sass-lint --config #{ui_library_path_relative}/scss/.sass-lint.yml
                  #{ui_library_path_relative}/scss/*.scss
                  -v -q --max-warnings=0
      LINT
      cmd.gsub(/\s +/, ' ').strip
    end
  end

  # ------------------------------
  # Utility methods

  def relative_path(path)
    pathname = path.respond_to?(:relative_path_from) ? path : Pathname.new(path)
    pathname.relative_path_from(project_path)
  end

  def valid_path(project_root)
    project_path = Pathname.new(project_root)
    return project_path if project_path.exist?
    raise ArgumentError, "Path #{project_root} does not exist"
  end

end

namespace :ui do
  ui_library = UILibrary.new(File.expand_path('../..', __dir__))

  desc 'Check CSS with scss-lint'
  task check: :environment do
    ui_library.check_scss!
  end

  desc 'Compile CSS from ui-library/scss to public/stylesheets'
  task compile: [:check] do
    ui_library.compile_css!
  end

end
