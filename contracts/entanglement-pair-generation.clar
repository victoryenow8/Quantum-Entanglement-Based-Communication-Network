;; Entanglement Pair Generation Contract

(define-map entangled-pairs
  { pair-id: uint }
  {
    particle1: principal,
    particle2: principal,
    creation-time: uint,
    fidelity: uint
  }
)

(define-data-var next-pair-id uint u0)

(define-public (generate-entangled-pair (particle1 principal) (particle2 principal))
  (let
    ((pair-id (var-get next-pair-id)))
    (var-set next-pair-id (+ pair-id u1))
    (ok (map-set entangled-pairs
      { pair-id: pair-id }
      {
        particle1: particle1,
        particle2: particle2,
        creation-time: block-height,
        fidelity: u100
      }
    ))
  )
)

(define-read-only (get-entangled-pair (pair-id uint))
  (map-get? entangled-pairs { pair-id: pair-id })
)

(define-public (update-fidelity (pair-id uint) (new-fidelity uint))
  (match (map-get? entangled-pairs { pair-id: pair-id })
    pair (ok (map-set entangled-pairs
      { pair-id: pair-id }
      (merge pair { fidelity: new-fidelity })
    ))
    (err u404)
  )
)

(define-read-only (is-entangled (pair-id uint))
  (match (map-get? entangled-pairs { pair-id: pair-id })
    pair (> (get fidelity pair) u50)
    false
  )
)

