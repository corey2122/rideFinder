//
//  RideMapView.swift
//  RideFinderApp
//
//  Created by Corey Schwarzkopf on 8/27/25.
//

import SwiftUI
import MapKit

struct RideMapView: UIViewRepresentable {
    let routeCoordinates: [CLLocationCoordinate2D]
    let start: CLLocationCoordinate2D?
    let end: CLLocationCoordinate2D?

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView(frame: .zero)
        mapView.delegate = context.coordinator
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.showsCompass = false
        mapView.pointOfInterestFilter = .excludingAll
        return mapView
    }

    func updateUIView(_ mapView: MKMapView, context: Context) {
        mapView.removeAnnotations(mapView.annotations)
        mapView.removeOverlays(mapView.overlays)

        if let s = start {
            let a = MKPointAnnotation(); a.coordinate = s; a.title = "Start"; mapView.addAnnotation(a)
        }
        if let e = end {
            let a = MKPointAnnotation(); a.coordinate = e; a.title = "End"; mapView.addAnnotation(a)
        }

        if !routeCoordinates.isEmpty {
            var coords = routeCoordinates
            let polyline = MKPolyline(coordinates: &coords, count: coords.count)
            mapView.addOverlay(polyline)
            let pad: CGFloat = 40
            mapView.setVisibleMapRect(polyline.boundingMapRect, edgePadding: UIEdgeInsets(top: pad, left: pad, bottom: pad, right: pad), animated: false)
        } else if !mapView.annotations.isEmpty {
            mapView.showAnnotations(mapView.annotations, animated: false)
        }
    }

    func makeCoordinator() -> Coordinator { Coordinator() }
    
    final class Coordinator: NSObject, MKMapViewDelegate {
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let line = overlay as? MKPolyline {
                let r = MKPolylineRenderer(polyline: line)
                r.strokeColor = .systemBlue
                r.lineWidth = 4
                r.lineJoin = .round
                r.lineCap = .round
                return r
            }
            return MKOverlayRenderer(overlay: overlay)
        }
    }
}
