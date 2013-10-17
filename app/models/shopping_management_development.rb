# coding:utf-8
class ShoppingManagementDevelopment < ActiveRecord::Base
  
#  attr_accessible :categoryCd,:goods,:amount,:sum,:place
  
  validates :categoryCd,
  :presence =>  { :message => "%{value}を入力してください" }
  validates :goods,
  :presence =>  { :message => "を入力してください" }
  validates :amount,
   :allow_nil => true,
   :numericality => { :greater_than_or_equal_to   => 0 ,:message => "は半角数字で入力してください"} , 
   :length => { :within => 0..6 ,:message => "は6文字以下で入力してください" } 
  validates :sum,
   :allow_nil => true,
   :numericality => { :greater_than => 0 ,:message => "は1以上で入力してください" ,
   :greater_than_or_equal_to   => 0,:message => "は半角数字で入力してください" } , 
   :length => { :within => 0..6 ,:message => "は6文字以下で入力してください" } 
  validates :place,
   :allow_nil => true,
   :length => { :within => 0..20 ,:message => "は20文字以下で入力してください" } 
    
end
