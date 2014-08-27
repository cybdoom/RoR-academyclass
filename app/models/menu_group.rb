class MenuGroup < ActiveRecord::Base
  has_many :menu_items, :order => :sequence, :dependent => :destroy
  validates_presence_of :label, :menu_column, :sequence
  validates_uniqueness_of :sequence, :scope => :menu_column
  validates_numericality_of :menu_column, :only_integer => true, :greater_than => 0
  attr_accessible :label, :url, :menu_column, :sequence, :lock_version
  before_validation :set_sequence

  scope :with_items, includes(:menu_items)
  scope :ordered, order(:menu_column, :sequence)

  def reorder_items(items)
    items.each_with_index do |id, i|
      menu_items.each do |item|
        if id.to_i == item.id
          item.sequence = i
          item.save
        end
      end
    end
  end

  validates_each :menu_column do |record, attr, value|
    if value && value.is_a?(Numeric)

      if value > (MenuGroup.max_column_num + 1)
        record.errors.add(:menu_column, "too high")
      end

      if !record.new_record? && (record.menu_column_was != value)
        if (record.menu_column_was < MenuGroup.max_column_num) || (value > MenuGroup.max_column_num)
          if MenuGroup.where(menu_column: record.menu_column_was).count == 1
            record.errors.add(:menu_column, "Can't move")
          end
        end
      end

    end
  end

  def self.max_column_num
    MenuGroup.select("max(menu_column) as max").first.try(:max) || 0
  end

  private

    def set_sequence
      self.sequence = nil if menu_column_changed?

      if sequence.nil?
        last = MenuGroup.where(:menu_column => menu_column).order(:sequence).last
        self.sequence = last ? last.sequence + 1 : 1
      end
    end

end
