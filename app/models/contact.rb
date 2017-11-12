class Contact < ApplicationRecord
  enum kind:        { email: "envelope", telephone: "phone", address: "map",  social: "social" }
  enum social_type: { instagram:   "instagram",   facebook: "facebook",  vk:    "vk",    twitter: "twitter",
                      google_plus: "google-plus", telegram: "telegram",   skype: "skype", tumblr:  "tumblr",
                      whatsapp:     "whatsapp",   youtube:  "youtube",    vimeo: "vimeo", slack:  "slack" }

  validates :kind, :value,  presence: true
  validates :social_type,   presence: true,               if: -> { kind == "social" }
  validates :kind,        uniqueness: true,               if: -> { kind == "email"  }
  validates_format_of :value, with: Devise::email_regexp, if: -> { kind == "email"  }
end
