def gets
  if Thread.current.thread_variable_get(:gets_mode) == :random
    val = %w(佐藤 鈴木 高橋 田中 伊藤 渡辺 山本 中村 小林 加藤 吉田 AAA 5).sample
    Thread.current.thread_variable_get(:sample) << val
    logger.debug "gets random #{val}"
    val
  else
    val = Thread.current.thread_variable_get(:input)&.shift
    logger.debug "gets replay #{val}"
    val
  end
end

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
    Thread.current.thread_variable_set :sample, []
    Thread.current.thread_variable_set :gets_mode, :random

    begin
      $stdout = StringIO.new
      eval solution
      Thread.current.thread_variable_get :sample
    rescue => e
      logger.debug e
      bc = ActiveSupport::BacktraceCleaner.new
      bc.add_silencer { |line| line =~ %r{gems} }
      logger.debug bc.clean(e.backtrace).join("\n")
      logger.debug solution
      raise
    ensure
      $stdout = STDOUT
    end
  end

  def result
    Thread.current.thread_variable_set :input, Thread.current.thread_variable_get(:sample)
    Thread.current.thread_variable_set :gets_mode, :replay

    begin
      $stdout = StringIO.new
      eval solution
      $stdout.string
    ensure
      $stdout = STDOUT
    end
  end

  private

  def markdown
    @markdown ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true)
  end
end
