require 'thor'

class {{input:name}} < Thor
  class_option :help, :type => :boolean, :aliases => '-h', :desc => 'Help message.'

  desc "add", "description"
  def add()
    if args.empty?
    end
  end

  no_tasks do
    # デフォルトメソッドを上書きして -h を処理
    # defined in /lib/thor/invocation.rb
    def invoke_task(task, *args)
      if options[:help]
        Demo.task_help(shell, task.name)
      else
        super
      end
    end
  end

  protected
  def args_or_pipe(args, stdin)
    if not args.empty?
      args
    elsif File.pipe?(stdin)
      stdin.readlines.map{|v| v.chomp}
    else
      []
    end
  end
end
