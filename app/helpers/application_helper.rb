module ApplicationHelper
  def candidates
    [
      "Jill Stein",
      "Gary Johnson",
      "Hillary Clinton",
      "Donald Trump",
      "Evan McMullin"
    ]
  end

  def tweet_params
    {
      text: "Help keep Trump out of the White House.",
      url: root_url,
      hashtags: "defeatdonald"
    }
  end
end
