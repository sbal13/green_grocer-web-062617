require 'pry'
def consolidate_cart(cart)

  new_cart = Hash.new

  cart.each do |item|
    item.each do |name,values|
      if new_cart.has_key?(name)
        new_cart[name][:count] += 1
      else
        new_cart[name] = values
        new_cart[name][:count] = 1
      end
    end
  end

  new_cart
end

def apply_coupons(cart, coupons)
  coupons.each do |coupon|

    if cart.has_key?(coupon[:item])
      next if cart[coupon[:item]][:count] < coupon[:num]

      cart["#{coupon[:item]} W/COUPON"] ||= {price: coupon[:cost], clearance: cart[coupon[:item]][:clearance]}

      cart[coupon[:item]][:count] -= coupon[:num]

      if cart["#{coupon[:item]} W/COUPON"].has_key?(:count)
        cart["#{coupon[:item]} W/COUPON"][:count] += 1
      else
        cart["#{coupon[:item]} W/COUPON"][:count] = 1
      end

    end
  end

  cart
end

def apply_clearance(cart)
  cart.each{|item, stats| stats[:price] = (stats[:price]*0.8).round(2) if stats[:clearance]}
  cart
end

def checkout(cart, coupons)
  cart = consolidate_cart(cart)
  apply_coupons(cart, coupons)
  apply_clearance(cart)
  final = cart.collect do |item, stats|
    stats[:price]*stats[:count]
  end.reduce(:+)

  final = (final*0.9).round(2) if final > 100

  final
end
