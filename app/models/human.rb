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
    stdin, @sample = Eval.random_gets(source_type)
    Eval.wrap_eval stdin, solution
    @sample
  end

  def result
    Eval.wrap_eval Eval.repeat_gets(@sample), solution
  end

  private

  def markdown
    @markdown ||= Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true)
  end
end
