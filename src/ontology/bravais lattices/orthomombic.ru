PREFIX obo: <http://purl.obolibrary.org/obo/>

INSERT {
  ?x a obo:CRYO_0000384 . # Inferred Trigonal Lattice
}
WHERE {
  # Core structural bindings
  ?x a obo:CRYO_0000001 . # Crystal Lattice
  ?x obo:RO_0000086 ?a_param, ?b_param, ?c_param, ?alpha, ?beta, ?gamma .
  
  ?a_param a obo:CRYO_0000003 . # a parameter
  ?b_param a obo:CRYO_0000004 . # b parameter
  ?c_param a obo:CRYO_0000005 . # c parameter
  ?alpha   a obo:CRYO_0000037 . # α angle
  ?beta    a obo:CRYO_0000038 . # β angle
  ?gamma   a obo:CRYO_0000039 . # γ angle

  # Pulling the numerical values through PMD and OBI
  ?a_param obo:PMD_0000077 [ obo:OBI_0001937 ?num_a ] .
  ?b_param obo:PMD_0000077 [ obo:OBI_0001937 ?num_b ] .
  ?c_param obo:PMD_0000077 [ obo:OBI_0001937 ?num_c ] .
  
  ?alpha   obo:PMD_0000077 [ obo:OBI_0001937 ?num_alpha ] .
  ?beta    obo:PMD_0000077 [ obo:OBI_0001937 ?num_beta ] .
  ?gamma   obo:PMD_0000077 [ obo:OBI_0001937 ?num_gamma ] .

  # Mathematical filters matching your exact rule
  FILTER (?num_a != ?num_b && ?num_a != ?num_c && ?num_b != ?num_c)
  FILTER (?num_alpha = 90 && ?num_gamma = 90 && ?num_beta = 90)
}