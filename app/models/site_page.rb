class SitePage < ApplicationRecord

  require 'nokogiri'
  require 'open-uri'

  attr_accessor :target_url

  belongs_to  :user
  has_many  :campaigns

  validates   :title, presence: true
  validates   :title, uniqueness: { case_sensitive: false }, on: :create

  def self.convert(content, site_url)

    site_url = site_url.chomp('/')

    doc = Nokogiri::HTML(content)

    doc.css("link").each do |data|
      if data.attributes['href']
        case data.attributes['href']
        when /^\//
          data.attributes['href'].value = "#{site_url}#{data.attributes['href'].value}"
        when /^http/
          data.attributes['href'].value = data.attributes['href'].value
        when /^https/
          data.attributes['href'].value = data.attributes['href'].value
        when /^\.\./
          data.attributes['href'].value = "#{site_url}" + (data.attributes['href'].value.gsub /^\.\./, "").to_s
        when /^\/\.\./
          data.attributes['href'].value = "#{site_url}" + (data.attributes['href'].value.gsub /^\/\.\./, "").to_s
        else
          data.attributes['href'].value = "#{site_url}/#{data.attributes['href'].value}"
        end
      end
    end

    doc.css("a").each do |data|
      if data.attributes['href']
        case data.attributes['href']
        when /^\//
          data.attributes['href'].value = "#{site_url}#{data.attributes['href'].value}"
        when /^http/
          data.attributes['href'].value = data.attributes['href'].value
        when /^https/
          data.attributes['href'].value = data.attributes['href'].value
        when /^\.\./
          data.attributes['href'].value = "#{site_url}" + (data.attributes['href'].value.gsub /^\.\./, "").to_s
        when /^\/\.\./
          data.attributes['href'].value = "#{site_url}" + (data.attributes['href'].value.gsub /^\/\.\./, "").to_s
        else
          data.attributes['href'].value = "#{site_url}/#{data.attributes['href'].value}"
        end
      end
    end

    doc.css("script").each do |data|
      if data.attributes['src']
        case data.attributes['src']
        when /^\//
          data.attributes['src'].value = "#{site_url}#{data.attributes['src'].value}"
        when /^http/
          data.attributes['src'].value = data.attributes['src'].value
        when /^https/
          data.attributes['src'].value = data.attributes['src'].value
        when /^\.\./
          data.attributes['src'].value = "#{site_url}" + (data.attributes['src'].value.gsub /^\.\./, "").to_s
        when /^\/\.\./
          data.attributes['src'].value = "#{site_url}" + (data.attributes['src'].value.gsub /^\/\.\./, "").to_s
        else
          data.attributes['src'].value = "#{site_url}/#{data.attributes['src'].value}"
        end
      end
    end

    doc.css("img").each do |data|
      if data.attributes['src']
        case data.attributes['src']
        when /^\//
          data.attributes['src'].value = "#{site_url}#{data.attributes['src'].value}"
        when /^http/
          data.attributes['src'].value = data.attributes['src'].value
        when /^https/
          data.attributes['src'].value = data.attributes['src'].value
        when /^\.\./
          data.attributes['src'].value = "#{site_url}" + (data.attributes['src'].value.gsub /^\.\./, "").to_s
        when /^\/\.\./
          data.attributes['src'].value = "#{site_url}" + (data.attributes['src'].value.gsub /^\/\.\./, "").to_s
        else
          data.attributes['src'].value = "#{site_url}/#{data.attributes['src'].value}"
        end
      end
    end

    doc.css("td").each do |data|
      if data.attributes['background']
        case data.attributes['background']
        when /^\//
          data.attributes['background'].value = "#{site_url}#{data.attributes['background'].value}"
        when /^http/
          data.attributes['background'].value = data.attributes['background'].value
        when /^https/
          data.attributes['background'].value = data.attributes['background'].value
        when /^\.\./
          data.attributes['background'].value = "#{site_url}" + (data.attributes['background'].value.gsub /^\.\./, "").to_s
        when /^\/\.\./
          data.attributes['background'].value = "#{site_url}" + (data.attributes['background'].value.gsub /^\/\.\./, "").to_s
        else
          data.attributes['background'].value = "#{site_url}/#{data.attributes['background'].value}"
        end
      end
    end

    doc.css("iframe").each do |data|
      if data.attributes['src']
        case data.attributes['src']
        when /^\//
          data.attributes['src'].value = "#{site_url}#{data.attributes['src'].value}"
        when /^http/
          data.attributes['src'].value = data.attributes['src'].value
        when /^https/
          data.attributes['src'].value = data.attributes['src'].value
        when /^\.\./
          data.attributes['src'].value = "#{site_url}" + (data.attributes['src'].value.gsub /^\.\./, "").to_s
        when /^\/\.\./
          data.attributes['src'].value = "#{site_url}" + (data.attributes['src'].value.gsub /^\/\.\./, "").to_s
        else
          data.attributes['src'].value = "#{site_url}/#{data.attributes['src'].value}"
        end
      end
    end

    doc.css("input").each do |data|
      if data.attributes['src']
        case data.attributes['src']
        when /^\//
          data.attributes['src'].value = "#{site_url}#{data.attributes['src'].value}"
        when /^http/
          data.attributes['src'].value = data.attributes['src'].value
        when /^https/
          data.attributes['src'].value = data.attributes['src'].value
        when /^\.\./
          data.attributes['src'].value = "#{site_url}" + (data.attributes['src'].value.gsub /^\.\./, "").to_s
        when /^\/\.\./
          data.attributes['src'].value = "#{site_url}" + (data.attributes['src'].value.gsub /^\/\.\./, "").to_s
        else
          data.attributes['src'].value = "#{site_url}/#{data.attributes['src'].value}"
        end
      end
    end

    doc.css("frame").each do |data|
      if data.attributes['src']
        case data.attributes['src']
        when /^\//
          data.attributes['src'].value = "#{site_url}#{data.attributes['src'].value}"
        when /^http/
          data.attributes['src'].value = data.attributes['src'].value
        when /^https/
          data.attributes['src'].value = data.attributes['src'].value
        when /^\.\./
          data.attributes['src'].value = "#{site_url}" + (data.attributes['src'].value.gsub /^\.\./, "").to_s
        when /^\/\.\./
          data.attributes['src'].value = "#{site_url}" + (data.attributes['src'].value.gsub /^\/\.\./, "").to_s
        else
          data.attributes['src'].value = "#{site_url}/#{data.attributes['src'].value}"
        end
      end
    end

    return doc.to_s
  end

  def self.redirect_form_action(content, token, root_url)
    doc = Nokogiri::HTML(content)

    doc.css("form").each do |form|
      if form.attributes['action']
        form.attributes['action'].value = root_url + "activate/" + token
      end
    end

    return doc.to_s
  end

end
