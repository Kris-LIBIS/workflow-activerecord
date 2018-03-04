require 'libis/workflow/worker'
require 'sidekiq'

module Libis
  module Workflow
    module ActiveRecord

      class Worker < Libis::Workflow::Worker

        def get_job(job_config)
          job_name = job_config.delete(:name)
          job = ::Libis::Workflow::ActiveRecord::Job.find(name: job_name).first
          raise RuntimeError.new "Workflow #{job_name} not found" unless job.is_a? ::Libis::Workflow::ActiveRecord::Job
          job
        end

      end
    end
  end
end
