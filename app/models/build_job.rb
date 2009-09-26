class BuildJob < Struct.new(:build_id, :payload)
  attr_accessor :build, :project, :clone_url
  def setup
    self.build = Build.find(build_id)
    repository = payload["repository"]
    self.project = Project.find_by_name(repository["name"])
    if !project
      puts "There is no project."
      exit!
    end
    self.clone_url = repository["clone_url"] || "git@#{build.site}:#{repository["owner"]["name"]}/#{repository["name"]}.git"
    # Will have to have different directories for the different branches at one point.
    if !File.exist?(File.join(project.build_directory, ".git"))
      clone_repo
    end
    branch = build.branch
     
    Dir.chdir(project.build_directory) do
      checkout_branch
    end
  end
  
  def perform
    setup
    Dir.chdir(project.build_directory) do
      @build.update_attribute("status", "running the build")
      @build.stdout = ""
      @build.stderr = ""
      POpen4::popen4(project.instructions) do |stdout, stderr, stdin, pid|        
        @build.stdout << stdout.read.strip
        @build.stderr << stderr.read.strip
      end
      
      @build.update_attribute("status", $?.success? ? "success" : "failed")
      # Just to ensure...
      @build.save!
    end
    @build
  end
  
  # Helper method for running steps that will follow the same ol' pending, succeed/failed chain of events.
  def run_step(command, pending="pending", success="success", failure="failed")
    POpen4::popen4(command) do |stdout, stderr, stdin, pid|
      @build.stderr = stderr.read
      @build.stdout = stdout.read
    end
    
    if $?.success? 
      @build.update_attribute(:status, success)
    else 
      @build.update_attribute(:status, failure)
    end
    $?.success?
  end
  
  def checkout_branch
    branch = build.branch.name
    Dir.chdir(project.build_directory) do
      output = ""
      POpen4::popen4("git checkout origin/#{branch} -b #{branch}") do |stdout, stderr, stdin, pid|        
        output << stdout.read.strip
        output << stderr.read.strip
      end
      if $?.success?
        @build.update_attribute(:status, "checked out remote branch #{branch}")
      else
        if output =~ /already exists$/
          @build.update_attribute(:status, "branch #{branch} already exists, proceeding")
        else
          @build.update_attribute(:status, "something went wrong whilst checking out the branch #{branch}: #{output}")
        end
      end
      $?.success?
    end
  end
  
  def clone_repo
     run_step("git clone #{clone_url} #{project.build_directory}", "setting up repository", "set up repository", "failed to set up repository")
   end
end
