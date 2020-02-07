require "stringio"

@result

begin
  stream = :stdout.to_s
  eval "$#{stream} = StringIO.new"
  eval "p 123"
  @result = eval("$#{stream}").string
ensure
  eval("$#{stream} = #{stream.upcase}")
end

p 'hi'
p @result
p 'boo'