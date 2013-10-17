class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      # カテゴリTBL
      # $ rake db:migrate:up VERSION=20131017022458
      
      #t.type       :<column>
      t.integer     :categorycd     , null: false  # カテゴリコード
      t.string      :categoryname   , null: false  # カテゴリ名
      t.integer     :outturn        , null: false  # 表示順
      t.timestamps                                 # タイムスタンプ(デフォルト)
    end
  end
end
