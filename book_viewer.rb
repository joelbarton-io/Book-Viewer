require "tilt/erubis"
require "sinatra"
require "sinatra/reloader"

before do
  @contents = File.readlines("data/toc.txt")
end

get "/" do
  @title = "The Adventures of Sherlock Holmes"
  erb :home
end

get "/chapters/:number" do
  number = params["number"].to_i
  @chapter_name = @contents[number - 1]
  @title = "Chapter #{number}: #{@chapter_name}"

  @chapter = File.read("data/chp#{number}.txt")

  erb :chapter
end

get "/show/:name" do params["name"] end

helpers do

  def in_paragraphs(text)
    text.split("\n\n").map do |paragraph|
      "<p>#{paragraph}</p>"
    end.join
  end

  # Calls the block for each chapter, passing that chapter's number, name, and
  # contents.
  def each_chapter
    @contents.each_with_index do |name, index|
      number = index + 1
      contents = File.read("data/chp#{number}.txt")
      yield number, name, contents
    end
  end

  # This method returns an Array of Hashes representing chapters that match the
  # specified query. Each Hash contain values for its :name and :number keys.
  def chapters_matching(query)
    results = []

    return results if !query || query.empty?

    each_chapter do |number, name, contents|
      results << {number: number, name: name} if contents.include?(query)
    end

    results
  end


end

# not_found do
#   redirect "/"
# end

get "/search" do
  @results = chapters_matching(params[:query])
  erb :search
end


# Rascal died today.  We buried him out in the yard back behind the garden box.
# Spring has been hinting its arrival for weeks now, but over the last few days
# Winter delivered one last offering of snow and a promise to drag on for at least another few weeks.
# This stubborn persistence of season is something we as montanans are well-
# acquainted with; winter always gets the last word.

# Rascal was the son of my Mother's dog "auggie" who was taken from us far too early. I can still remember how her last few days made me feel: a helplessness that ensnared all lighthearted memories we'd all had together with her as a family.

# The death of a dog is never easy, and Rascal wasn't even the puppy I wanted our family to keep from the litter.  Perhaps this fact colored our relationship from the start because we were never the best of pals over the 14 years; always slightly standoffish on my end or transactional on his.

# I'm not saying I didn't love rascal; I did, we all did.  It's just that noone
# loved him like my dad.  His was the type of love that, as a retired anesthesiologist, compelled him to