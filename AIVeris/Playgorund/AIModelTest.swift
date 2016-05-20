//
//  AIModelTest.swift
//  AIVeris
//
// Copyright (c) 2016 ___ASIAINFO___
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation

struct AIModelTest {
    
    static func testRouteArrayModel() -> [AIServiceRouteAddressModel] {
        var model1 = AIServiceRouteAddressModel()
        model1.sr_address_hour = 1
        model1.sr_address_name = "Hubei"
        var model2 = AIServiceRouteAddressModel()
        model2.sr_address_hour = 2
        model2.sr_address_name = "Zhejiang"
        var model3 = AIServiceRouteAddressModel()
        model3.sr_address_hour = 4
        model3.sr_address_name = "Beijing"
        var model4 = AIServiceRouteAddressModel()
        model4.sr_address_hour = 7
        model4.sr_address_name = "Shanghai"
        
        return [model1,model2,model3,model4]
    }
    
    static func testShoppingListModel() -> [AIShoppingModel] {
        
        var model1 = AIShoppingModel()
        model1.shopping_id = 1
        model1.shopping_price = "$ 2.5"
        model1.shopping_state = 0
        model1.shopping_title = "Creamy, dreamy, and ready in seconds (literally), this lighter latte saves you money and time‚ and it tastes absolutely divine."
        model1.shopping_image_url = "http://img1.cookinglight.timeinc.net/sites/default/files/styles/400xvariable/public/image/2011/06/1106p38-pineapple-chicken-satay-m.jpg?itok=cjX81_WY"
        model1.shopping_number = 4
        
        
        var model2 = AIShoppingModel()
        model2.shopping_id = 1
        model2.shopping_price = "$ 3"
        model2.shopping_state = 0
        model2.shopping_title = "Craving pancakes for one? No problem! These 3-ingredient pancakes pack in a mighty 10 grams of protein and are ready in a 10-minute snap. "
        model2.shopping_image_url = "http://img1.cookinglight.timeinc.net/sites/default/files/styles/400xvariable/public/image/Oxmoor/oh-fff-p216-tilapia-olive-m.jpg?itok=idiZOtnv"
        model2.shopping_number = 4
        
        
        var model3 = AIShoppingModel()
        model3.shopping_id = 1
        model3.shopping_price = "$ 8.5"
        model3.shopping_state = 0
        model3.shopping_title = "Our crowd-pleasing appetizer is rich and creamy without excess fat and calories. Learn how we made over this all-time favorite."
        model3.shopping_image_url = "http://img1.cookinglight.timeinc.net/sites/default/files/styles/400xvariable/public/image/2016/04/main/1605p46-bbq-chicken-sandwiches-with-coleslaw_0.jpg?itok=u0iiwSbg"
        model3.shopping_number = 8
        
        
        var model4 = AIShoppingModel()
        model4.shopping_id = 1
        model4.shopping_price = "$ 2"
        model4.shopping_state = 0
        model4.shopping_title = "Watch Allison Fishman use six ingredients to make one delicious dessert in less than 10 minutes."
        model4.shopping_image_url = "http://img1.cookinglight.timeinc.net/sites/default/files/styles/400xvariable/public/image/2015/05/main/1506p119-summer-veggie-pasta.jpg?itok=NdrTON5e"
        model4.shopping_number = 12
        
        
        var model5 = AIShoppingModel()
        model5.shopping_id = 1
        model5.shopping_price = "$ 1.5"
        model5.shopping_state = 0
        model5.shopping_title = "Pizza's a real crowd-pleaser, perfect for any weeknight. Watch Bruce and Mark make Salad Bar Pizza and Barbecued Chicken Pizza using healthy convenience products."
        model5.shopping_image_url = "http://img1.cookinglight.timeinc.net/sites/default/files/styles/400xvariable/public/image/2010/09/1009p219-gemelli-broccoli-rabe-m.jpg?itok=gxs8On2j"
        model5.shopping_number = 4
        
        var model6 = AIShoppingModel()
        model6.shopping_id = 1
        model6.shopping_price = "$ 0.5"
        model6.shopping_state = 0
        model6.shopping_title = "Crispy, crunchy, and much less fat than fast food fries, our oven-baked variety is a healthy and delicious side."
        model6.shopping_image_url = "http://img1.cookinglight.timeinc.net/sites/default/files/styles/400xvariable/public/image/2008/08/0808p164c-grilled-chicken-m.jpg?itok=V6_i3mal"
        model6.shopping_number = 4
        
        
        return [model1,model2,model3,model4,model5,model6]
        
    }
}