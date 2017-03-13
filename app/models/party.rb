#
# Table Schema
# ------------
# id            - int(11)      - default NULL
# host_name     - varchar(255) - default NULL
# host_email    - varchar(255) - default NULL
# numgsts       - int(11)      - default NULL
# guest_names   - text         - default NULL
# venue         - varchar(255) - default NULL
# location      - varchar(255) - default NULL
# theme         - varchar(255) - default NULL
# when          - datetime     - default NULL
# when_its_over - datetime     - default NULL
# descript      - text         - default NULL
#
class Party < ApplicationRecord

  after_save :correct_name
  validate :host_name, :host_email, :venue, :location, :theme, :maximum => 255,
   :too_long => "Input was too long."
  validate :validations

  def validations
    # ruby doesn't like us using when as column name for some reason
    if self[:when] > when_its_over
      errors.add(:base,"Incorrect party time.")
    end

    if numgsts.nil?
      numgsts = 0
    end

    if venue.length > 0 && location.length < 0
      errors.add(:location,"Where is the party?")
    end
    if guest_names.split(',').size != numgsts
      errors.add(:guest_names,"Missing guest name")
    end
  end

  def correct_name
    # clean "Harry S. Truman" guest name to "Harry S._Truman"
    # clean "Roger      Rabbit" guest name to "Roger Rabbit"
    gnames = []
    guest_names.split(',').each do |g|
      g.squeeze!
      names = g.split(' ')
      gnames << "#{names[0]} #{names[1..-1].join('_')}"
    end
    guest_names = gnames
    save!
  end
end
