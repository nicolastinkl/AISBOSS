//
//  AIDetailNetService.swift
//  AIVeris
//
//  Created by tinkl on 21/9/2015.
//  Copyright © 2015 ___ASIAINFO___. All rights reserved.
//

import Foundation

class AIDetailNetService {
    private let JSON:String = "scheme_param_list=[param_key=0&param_value=123&param_value_id=1&param_key=0&param_value=123&param_value_id=1]&catalog_list=[relevant_level=1&catalog_name=European Fishmen's daily life&service_level=1&binding_flag=1&service_list=[service_id=1&service_name=Great fishing exprience.&service_price=123.3&service_intro=Fishing is the Best all yourself can be  expred on th brench.&provider_id=1&provider_name=tinkle&service_rating=12&provider_icon=http=//pic41.nipic.com/20140520/18505720_142810265175_2.jpg&service_img=http=//pic25.nipic.com/20121119/6835836_115116793000_2.jpg&service_param_list=[param_key=0&param_value=123&param_value_id=1&param_key=0&param_value=123&param_value_id=1]]&relevant_level=1&catalog_name=Punting Training&service_level=1&binding_flag=1&service_list=[service_id=1&service_name=different Cambrigde Trip&&service_price=123.3&service_intro=Fishing is the Best all yourself can be  expred on th brench.&provider_id=1&provider_name=tinkle&service_rating=12&provider_icon=http=//pic41.nipic.com/20140520/18505720_142810265175_2.jpg&service_img=http=//pic25.nipic.com/20121119/6835836_115116793000_2.jpg&service_param_list=[param_key=0&param_value=123&param_value_id=1&param_key=0&param_value=123&param_value_id=1]]&relevant_level=2&catalog_name=Accomandation&service_level=1&binding_flag=1&service_list=[service_id=1&service_name=Alex Tiller&service_price=123.3&service_intro=Fishing is the Best all yourself can be  expred on th brench.&provider_id=1&provider_name=tinkle&service_rating=12&provider_icon=http=//pic41.nipic.com/20140520/18505720_142810265175_2.jpg&service_img=http=//pic25.nipic.com/20121119/6835836_115116793000_2.jpg&service_param_list=[param_key=0&param_value=123&param_value_id=1&param_key=0&param_value=123&param_value_id=1]&service_id=1&service_name=RC Wagon Rental&service_price=123.3&service_intro=Fishing is the Best all yourself can be  expred on th brench.&provider_id=1&provider_name=tinkle&service_rating=12&provider_icon=http=//pic41.nipic.com/20140520/18505720_142810265175_2.jpg&service_img=http=//pic25.nipic.com/20121119/6835836_115116793000_2.jpg&service_param_list=[param_key=0&param_value=123&param_value_id=1&param_key=0&param_value=123&param_value_id=1]]&relevant_level=3&catalog_name=Touriset Visa Switch&service_level=1&binding_flag=1&service_list=[service_id=1&service_name=Alex Tiller&service_price=123.3&service_intro=Fishing is the Best all yourself can be  expred on th brench.&provider_id=1&provider_name=tinkle&service_rating=12&provider_icon=http=//pic41.nipic.com/20140520/18505720_142810265175_2.jpg&service_img=http=//pic25.nipic.com/20121119/6835836_115116793000_2.jpg&service_param_list=[param_key=0&param_value=123&param_value_id=1&param_key=0&param_value=123&param_value_id=1]&service_id=1&service_name=RC Wagon Rental&service_price=123.3&service_intro=Fishing is the Best all yourself can be  expred on th brench.&provider_id=1&provider_name=tinkle&service_rating=12&provider_icon=http=//pic41.nipic.com/20140520/18505720_142810265175_2.jpg&service_img=http=//pic25.nipic.com/20121119/6835836_115116793000_2.jpg&service_param_list=[param_key=0&param_value=123&param_value_id=1&param_key=0&param_value=123&param_value_id=1]]&relevant_level=4&catalog_name=Flights&service_level=1&binding_flag=1&service_list=[service_id=1&service_name=QR9988&service_price=123.3&service_intro=Fishing is the Best all yourself can be  expred on th brench.&provider_id=1&provider_name=tinkle&service_rating=12&provider_icon=http=//pic41.nipic.com/20140520/18505720_142810265175_2.jpg&service_img=http=//pic25.nipic.com/20121119/6835836_115116793000_2.jpg&service_param_list=[param_key=0&param_value=123&param_value_id=1&param_key=0&param_value=123&param_value_id=1]&service_id=1&service_name=QR874&service_price=123.3&service_intro=Fishing is the Best all yourself can be  expred on th brench.&provider_id=1&provider_name=tinkle&service_rating=12&provider_icon=http=//pic41.nipic.com/20140520/18505720_142810265175_2.jpg&service_img=http=//pic25.nipic.com/20121119/6835836_115116793000_2.jpg&service_param_list=[param_key=0&param_value=123&param_value_id=1&param_key=0&param_value=123&param_value_id=1]]]"
    
    
    
    func requestListServices(sheme_id: Int, completion: (AIServiceSchemeModel) -> Void) {
       
        
        let paras = [
            "data":[
                "sheme_id": sheme_id
            ],
            "desc":[
                "data_mode": 0,
                "digest": ""
            ]
        ]
        
        AIHttpEngine.postRequestWithParameters(AIHttpEngine.ResourcePath.QueryCollectedServices, parameters: paras) {  [weak self] (response, error) -> () in
            
            if let strongSelf = self{
                let model =  AIServiceSchemeModel(string: strongSelf.JSON, error:nil)
                completion(model)
            }
        }
        do {
            let model =  try AIServiceSchemeModel(data: NSString(string: self.JSON).dataUsingEncoding(NSUTF8StringEncoding))
            completion(model)
        } catch{
            print("catch cash")
        }
        
    }
    
}