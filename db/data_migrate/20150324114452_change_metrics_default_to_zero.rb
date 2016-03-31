class ChangeMetricsDefaultToZero < ActiveRecord::Migration
  def up
    Change.update_all(pdf: 0, html: 0, total: 0)
  end

  def down

  end
end
