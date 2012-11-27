module Bosh::Bootstrap::Stages
  class StagePrepareInceptionVm
    def commands
      @commands ||= Bosh::Bootstrap::Commander::Commands.new do |server|
        server.validate "ubuntu", script("validate_ubuntu")
        server.create "vcap user", script("create_vcap_user")
        server.install "base packages", script("install_base_packages")
        server.install "ruby 1.9.3", script("install_ruby")
        server.install "useful ruby gems", script("install_useful_gems")
        server.install "bosh", script("install_bosh")
        server.validate "bosh deployer", script("validate_bosh_deployer")
      end
    end

    private
    def stage_name
      "stage_prepare_inception_vm"
    end

    def script(segment_name)
      path = File.expand_path("../#{stage_name}/#{segment_name}", __FILE__)
      if File.exist?(path)
        File.read(path)
      else
        Thor::Base.shell.new.say_status "error", "Missing script lib/bosh-bootstrap/stages/#{stage_name}/#{segment_name}", :red
        exit 1
      end
    end
  end
end
