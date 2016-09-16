//
//  AppDelegate.swift
//  LeituraDeBolso
//
//  Created by Huallyd Smadi on 24/08/16.
//  Copyright © 2016 Lab262. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var maskBgView = UIView()

    func launchScreenAnimation () {
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
        let navigationController = mainStoryboard.instantiateViewController(withIdentifier: "navigation")
        self.window!.rootViewController = navigationController
        
        self.maskBgView.frame = navigationController.view.frame
        self.maskBgView.backgroundColor = UIColor.colorWithHexString("1BDBAD")
        
        navigationController.view.addSubview(self.maskBgView)
        
        let launchScreenImageView = UIImageView(image: UIImage(named: "LaunchScreenFrames1.png"))
        
        launchScreenImageView.frame = CGRect(x: 0, y: 0, width: 153, height: 153);
     
        launchScreenImageView.center = maskBgView.center
        
        maskBgView.addSubview(launchScreenImageView)
        
        var images = [CGImage]()
        
        for i in 1..<71 {
            
            images.append((UIImage(named: "LaunchScreenFrames\(i)")?.cgImage)!)
        }
        
        let animation: CAKeyframeAnimation = CAKeyframeAnimation(keyPath: "contents")
        
        animation.calculationMode = kCAAnimationDiscrete
        animation.duration = 70/24
        animation.values = images
        animation.repeatCount = 1
        animation.delegate = self
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        
        launchScreenImageView.layer.add(animation, forKey: "animation")
        
    }
    
   
    func initializeReads () {
        
        var arrayImages = [String]()
        
        //self.arrayImages.append("\u{1F603}")
      //  arrayImages.append("\u{1F603}")
        arrayImages.append("\u{1F603}")
        arrayImages.append("\u{1F603}")
        arrayImages.append("\u{1F603}")
        
        
        
        ApplicationState.sharedInstance.allReadings.append(Reading(_title: "A Cigarra e a Formiga", _author: "La Fontaine", _emojis: arrayImages, _duration: "21 min", _text: "Era uma vez uma cigarra que vivia saltitando e cantando pelo bosque, sem se preocupar com o futuro. Esbarrando numa formiguinha, que carregava uma folha pesada, perguntou: Ei, formiguinha, para que todo esse trabalho? O verão é para gente aproveitar! O verão é para gente se divertir! Não, não, não! Nós, formigas, não temos tempo para diversão. É preciso trabalhar agora para guardar comida para o inverno. Durante o verão, a cigarra continuou se divertindo e passeando por todo o bosque. Quando tinha fome, era só pegar uma folha e comer.  Um belo dia, passou de novo perto da formiguinha carregando outra pesada folha."))
        
       
        ApplicationState.sharedInstance.allReadings.append(Reading(_title: "A Lebre e a Tartaruga", _author: " Christiane Araújo Angelotti", _emojis: arrayImages, _duration: "20 min", _text: "Era uma vez... uma lebre e uma tartaruga. A lebre vivia caçoando da lerdeza da tartaruga. Certa vez, a tartaruga já muito cansada por ser alvo de gozações, desafiou a lebre para uma corrida. A lebre muito segura de si, aceitou prontamente. Não perdendo tempo, a tartaruga pois-se a caminhar, com seus passinhos lentos, porém, firmes. Logo a lebre ultrapassou a adversária, e vendo que ganharia fácil, parou e resolveu cochilar. Quando acordou, não viu a tartaruga e começou a correr. Já na reta final, viu finalmente a sua adversária cruzando a linha de chegada,, toda sorridente."))
        
        ApplicationState.sharedInstance.allReadings.append(Reading(_title: "Cinderela", _author: "Irmãos Grimm", _emojis: arrayImages, _duration: "90 min", _text: "Há muito tempo, aconteceu que a esposa de um rico comerciante adoeceu gravemente e, sentindo seu fim se aproximar, chamou sua única filha e disse: Querida filha, continue piedosa e boa menina que Deus a protegerá sempre. Lá do céu olharei por você, e estarei sempre a seu lado.Mal acabou de dizer isso, fechou os olhos e morreu. A jovem ia todos os dias visitar o túmulo da mãe, sempre chorando muito. Veio o inverno, e a neve cobriu o túmulo com seu alvo manto. Chegou a primavera, e o sol derreteu a neve. Foi então que o viúvo resolveu se casar outra vez. A nova esposa trouxe suas duas filhas, ambas bonitas, mas só exteriormente. As duas tinham a alma feia e cruel. A partir desse momento, dias difíceis começaram para a pobre enteada. Essa imbecil não vai ficar no quarto conosco! _Reclamaram as moças. O lugar dela é na cozinha! Se quiser comer pão, que trabalhe! Tiraram-lhe o vestido bonito que ela usava, obrigaram-na a vestir outro, velho e desbotado, e a calçar tamancos. Vejam só como está toda enfeitada, a orgulhosa princesinha de antes! -disseram a rir, levando-a para a cozinha. A partir de então, ela foi obrigada a trabalhar, da manhã à noite, nos serviços mais pesados. Era obrigada a se levantar de madrugada, para ir buscar água e acender o fogo. Só ela cozinhava e lavava para todos. Como se tudo isso não bastasse, as irmãs caçoavam dela e a humilhavam. Espalhavam lentilhas e feijões nas cinzas do fogão e obrigavam-na a catar um a um. À noite, exausta de tanto trabalhar, a jovem não tinha onde dormir e era obrigada a se deitar nas cinzas do fogão. E, como andasse sempre suja e cheia de cinza, só a chamavam de Cinderela. Uma vez, o pai resolveu ir a uma feira. Antes de sair, perguntou às enteadas o que desejavam que ele trouxesse."))
        
        ApplicationState.sharedInstance.allReadings.append(Reading(_title: "Pinóquio", _author: "Christiane Angelotti", _emojis: arrayImages, _duration: "10 min", _text: "Era uma vez, um senhor chamado Gepeto. Ele era um homem bom, que morava sozinho em uma bela casinha numa vila italiana. Gepeto era marceneiro, fazia trabalhos incríveis com madeira,brinquedos, móveis e muitos outros objetos. As crianças adoravam os brinquedos de Gepeto. Apesar de fazer a felicidade das crianças com os brinquedos de madeira, Gepeto sentia-se muito só, e por vezes triste. Ele queria muito ter tido um filho, e assim resolveu construir um amigo de madeira para si. O boneco ficou muito bonito, tão perfeito que Gepeto entusiasmou-se e deu-lhe o nome de Pinóquio. Os dias se passaram e Gepeto falava sempre com o Pinóquio, como se este fosse realmente um menino. Numa noite, a Fada Azul visitou a oficina de Gepeto. Comovida com a solidão do bondoso ancião, resolveu tornar seu sonho em realidade dando vida ao boneco de madeira. E tocando Pinóquio com a sua varinha mágica disse: Te darei o dom da vida, porém para se transformar num menino de verdade deves fazer por merecer . Deve ser sempre bom e verdadeiro como o seu pai, Gepeto. A fada incumbiu um saltitante e esperto grilo na tarefa de ajudar Pinóquio a reconhecer o certo e o errado, dessa forma poderia se desenvolver mais rápido e alcançar seu almejado sonho: tornar-se um menino de verdade. No dia seguinte, ao acordar, Gepeto percebeu-se que o seu desejo havia se tornado realidade.Gepeto, que já amava aquele boneco de madeira como seu filho, agora descobria o prazer de acompanhar suas descobertas, observar sua inocência, compartilhar sua vivacidade. Queria ensinar ao seu filho, tudo o que sabia e retribuir a felicidade que o boneco lhe proporcionava. Sendo assim, Gepeto resolveu matricular Pinóquio na escola da vila, para que ele pudesse aprender as coisas que os meninos de verdade aprendem, além de fazer amizades. Pinóquio seguia a caminho da escola todo contente pensando em como deveria ser seu primeiro dia de aula estava ansioso para aprender a ler e escrever. No caminho porém encontrou dois estranhos que logo foram conversando com ele. Era uma Raposa e um Gato, que ficaram maravilhados ao ver um boneco de madeira falante e pensaram em ganhar dinheiro às custas do mesmo."))

        ApplicationState.sharedInstance.unreadReadings.append(Reading(_title: "Cinderela", _author: "Irmãos Grimm", _emojis: arrayImages, _duration: "90 min", _text: "Há muito tempo, aconteceu que a esposa de um rico comerciante adoeceu gravemente e, sentindo seu fim se aproximar, chamou sua única filha e disse: Querida filha, continue piedosa e boa menina que Deus a protegerá sempre. Lá do céu olharei por você, e estarei sempre a seu lado.Mal acabou de dizer isso, fechou os olhos e morreu. A jovem ia todos os dias visitar o túmulo da mãe, sempre chorando muito. Veio o inverno, e a neve cobriu o túmulo com seu alvo manto. Chegou a primavera, e o sol derreteu a neve. Foi então que o viúvo resolveu se casar outra vez. A nova esposa trouxe suas duas filhas, ambas bonitas, mas só exteriormente. As duas tinham a alma feia e cruel. A partir desse momento, dias difíceis começaram para a pobre enteada. Essa imbecil não vai ficar no quarto conosco! _Reclamaram as moças. O lugar dela é na cozinha! Se quiser comer pão, que trabalhe! Tiraram-lhe o vestido bonito que ela usava, obrigaram-na a vestir outro, velho e desbotado, e a calçar tamancos. Vejam só como está toda enfeitada, a orgulhosa princesinha de antes! -disseram a rir, levando-a para a cozinha. A partir de então, ela foi obrigada a trabalhar, da manhã à noite, nos serviços mais pesados. Era obrigada a se levantar de madrugada, para ir buscar água e acender o fogo. Só ela cozinhava e lavava para todos. Como se tudo isso não bastasse, as irmãs caçoavam dela e a humilhavam. Espalhavam lentilhas e feijões nas cinzas do fogão e obrigavam-na a catar um a um. À noite, exausta de tanto trabalhar, a jovem não tinha onde dormir e era obrigada a se deitar nas cinzas do fogão. E, como andasse sempre suja e cheia de cinza, só a chamavam de Cinderela. Uma vez, o pai resolveu ir a uma feira. Antes de sair, perguntou às enteadas o que desejavam que ele trouxesse."))
        
            ApplicationState.sharedInstance.favoriteReads.append(Reading(_title: "A Lebre e a Tartaruga", _author: " Christiane Araújo Angelotti", _emojis: arrayImages, _duration: "20 min", _text: "Era uma vez... uma lebre e uma tartaruga. A lebre vivia caçoando da lerdeza da tartaruga. Certa vez, a tartaruga já muito cansada por ser alvo de gozações, desafiou a lebre para uma corrida. A lebre muito segura de si, aceitou prontamente. Não perdendo tempo, a tartaruga pois-se a caminhar, com seus passinhos lentos, porém, firmes. Logo a lebre ultrapassou a adversária, e vendo que ganharia fácil, parou e resolveu cochilar. Quando acordou, não viu a tartaruga e começou a correr. Já na reta final, viu finalmente a sua adversária cruzando a linha de chegada, toda sorridente."))

        

        
        
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        self.launchScreenAnimation()
        
        self.setupBarsAppearance()
        
        self.initializeReads()
        
        return true
    }
    

    func setupBarsAppearance(){
        
        
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        
        let button = UIBarButtonItem.appearance()
        
        // Color of placeholder
        UILabel.appearance(whenContainedInInstancesOf: [UITextField.self]).textColor = UIColor.readingBlueColor()
        
        // Color and font of navigation bar
        UINavigationBar.appearance().isTranslucent = false
        
        UINavigationBar.appearance().tintColor = UIColor.blue
        
        //Title color of navigation bar
        UINavigationBar.appearance().titleTextAttributes =
            ([NSFontAttributeName: UIFont(name: "Quicksand-Bold", size: 20)!,
                NSForegroundColorAttributeName: UIColor.white])
        
        button.setTitleTextAttributes(([NSFontAttributeName: UIFont(name: "Quicksand-Bold", size: 14)!,
            NSForegroundColorAttributeName: UIColor.readingBlueColor()]), for: UIControlState())
 
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var applicationDocumentsDirectory: URL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "Lab262.LeituraDeBolso" in the application's documents Application Support directory.
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()

    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        let modelURL = Bundle.main.url(forResource: "LeituraDeBolso", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()

    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        // Create the coordinator and store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("SingleViewCoreData.sqlite")
        var failureReason = "There was an error creating or loading the application's saved data."
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?

            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
        }
        
        return coordinator
    }()

    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
        }
    }

}

extension AppDelegate: CAAnimationDelegate {
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        
        UIView.animate(withDuration: 0.8, animations: {
            self.maskBgView.alpha = 0.0
            }, completion: { (finished) in
                
                if finished {
                    self.maskBgView.removeFromSuperview()
                }
        })
        
    }

    
}

