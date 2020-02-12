class AddSourceTypeToHuman < ActiveRecord::Migration[6.0]
  def change
    add_column :humen, :source_type, :string
  end
end
