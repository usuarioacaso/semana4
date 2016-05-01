//
//  ViewController.swift
//  MarcaRuta
//
//  Created by Adrian Camacho Soriano on 30/04/16.
//  Copyright © 2016 Adrian Camacho Soriano acaso. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapa: MKMapView!
    
    private let manejador = CLLocationManager()
    private var latitud: CLLocationDegrees = CLLocationDegrees()
    private var longitud = CLLocationDegrees()
    private var startLocation = CLLocation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manejador.delegate = self
        manejador.desiredAccuracy = kCLLocationAccuracyBest
        manejador.requestWhenInUseAuthorization()
        
        startLocation = CLLocation(latitude: latitud, longitude: longitud)
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse{
            manejador.startUpdatingLocation()
            mapa.showsUserLocation = true
        }else{
            manejador.stopUpdatingLocation()
            mapa.showsUserLocation = false
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001))
        mapa.setRegion(region, animated: true)
        let latitud = manager.location!.coordinate.latitude
        let longitud = manager.location!.coordinate.longitude
        print("lat: \(latitud)")
        print("long: \(longitud)")

        let pin = MKPointAnnotation()
        pin.coordinate = CLLocationCoordinate2D(latitude: latitud, longitude: longitud)
        pin.title = "Coordenadas: \(latitud) / \(longitud)"
        
        let distancia = startLocation.distanceFromLocation(location!)
        print("Dist: \(distancia)")
        pin.subtitle = "Distancia: \(distancia)"
        
        mapa.addAnnotation(pin)
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("Errors:" + error.localizedDescription)
    }

    @IBAction func mapaNormal(sender: UIButton) {
        mapa.mapType = MKMapType.Standard
    }

    @IBAction func mapaSatelite(sender: UIButton) {
        mapa.mapType = MKMapType.Satellite
    }
    
    @IBAction func mapaHibrido(sender: UIButton) {
        mapa.mapType = MKMapType.Hybrid
    }
    
}

