def gets
  %w(佐藤 鈴木 高橋 田中 伊藤 渡辺 山本 中村 小林 加藤 吉田).sample
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

  def result
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
