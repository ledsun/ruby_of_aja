class Human < ApplicationRecord
  belongs_to :category

  def problem_html
    markdown.render problem
  end

  def solution_html
    CodeRay.scan(solution, :ruby).div(:line_numbers => :table)
  end

  def aim_html
    markdown.render aim
  end

  def input
    stdin, @sample = random_gets
    wrap_eval stdin
    @sample
  end

  def result
    wrap_eval repeat_gets(@sample)
  end

  private

  def markdown
    @markdown ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true)
  end

  def random_gets
    sample = []
    stdin = Object.new
    stdin.singleton_class.instance_eval do
      define_method 'gets' do
        val = %w(佐藤 鈴木 高橋 田中 伊藤 渡辺 山本 中村 小林 加藤 吉田 AAA 5).sample
        sample << val
        val
      end
    end

    [stdin, sample]
  end

  def repeat_gets(sample)
    stdin = Object.new
    stdin.singleton_class.instance_eval do
      define_method 'gets' do
        sample.shift
      end
    end

    stdin
  end

  def wrap_eval stdin
    begin
      $stdin = stdin
      $stdout = StringIO.new
      eval solution
      $stdout.string
    rescue => e
      logger.debug e
      bc = ActiveSupport::BacktraceCleaner.new
      bc.add_silencer { |line| line =~ %r{gems} }
      logger.debug bc.clean(e.backtrace).join("\n")
      logger.debug solution
      raise
    ensure
      $stdin = STDIN
      $stdout = STDOUT
    end
  end
end
