require "rake/task"

class SuiteTask < ::Rake::Task
  class SuiteError < StandardError; end

  def prerequisite_tasks(*)
    errors = (@suite_errors ||= [])
    @prerequisite_tasks ||= super.each do |task|
      task.define_singleton_method(:execute) do |*args|
        begin
          super(*args)
        rescue => e
          errors << e
        end
      end
    end
  end

  def invoke(*)
    super
    unless suite_errors.empty?
      fail SuiteError, ["The following errors occurred:", *suite_errors].join("\n  ")
    end
  end

  private

  def suite_errors
    @suite_errors ||= []
  end
end

def suite(*args, &block)
  SuiteTask.define_task(*args, &block)
end
