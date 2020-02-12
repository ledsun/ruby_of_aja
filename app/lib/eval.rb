module Eval
  def self.random_gets(source_type)
    source = if source_type == 'Integer'
               (1..15).map { _1.to_s }
             else
               %w(佐藤 鈴木 高橋 田中 伊藤 渡辺 山本 中村 小林 加藤 吉田 AAA)
             end
    sample = []
    stdin = Object.new
    stdin.singleton_class.instance_eval do
      define_method 'gets' do
        val = source.sample
        sample << val
        val
      end
    end

    [stdin, sample]
  end

  def self.repeat_gets(sample)
    stdin = Object.new
    stdin.singleton_class.instance_eval do
      define_method 'gets' do
        sample.shift
      end
    end

    stdin
  end

  def self.wrap_eval(stdin, ruby_script)
    begin
      $stdin = stdin
      $stdout = StringIO.new
      eval ruby_script
      $stdout.string
    rescue => e
      logger.debug e
      bc = ActiveSupport::BacktraceCleaner.new
      bc.add_silencer { |line| line =~ %r{gems} }
      logger.debug bc.clean(e.backtrace).join("\n")
      logger.debug ruby_script
      raise
    ensure
      $stdin = STDIN
      $stdout = STDOUT
    end
  end
end