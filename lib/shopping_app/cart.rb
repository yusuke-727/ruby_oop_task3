require_relative “item_manager”
require_relative “ownable”

class Cart
include ItemManager
include Ownable

attr_accessor :owner
attr_reader :items

def initialize(owner)
@owner = owner
@items = []
end

def items
# Cartにとってのitemsは自身の@itemsとしたいため、ItemManagerのitemsメソッドをオーバーライドします。
# CartインスタンスがItemインスタンスを持つときは、オーナー権限の移譲をさせることなく、自身の@itemsに格納(Cart#add)するだけだからです。
@items
end

def add(item)
@items « item
end

def total_amount
@items.sum(&:price)
end

def check_out
return if owner.wallet.balance < total_amount
# ## 要件
# - カートの中身（Cart#items）のすべてのアイテムの購入金額が、カートのオーナーのウォレットからアイテムのオーナーのウォレットに移されること。
# - カートの中身（Cart#items）のすべてのアイテムのオーナー権限が、カートのオーナーに移されること。
# - カートの中身（Cart#items）が空になること。
@items.each do |item|
@owner.wallet.withdraw(item.price)
item.owner.wallet.deposit(item.price)
item.owner = @owner
end

@items.clear
# ## ヒント
# - カートのオーナーのウォレット ==> self.owner.wallet
# - アイテムのオーナーのウォレット ==> item.owner.wallet
# - お金が移されるということ ==> (？)のウォレットからその分を引き出して、(？)のウォレットにその分を入金するということ
# - アイテムのオーナー権限がカートのオーナーに移されること ==> オーナーの書き換え(item.owner = ?)
end

end