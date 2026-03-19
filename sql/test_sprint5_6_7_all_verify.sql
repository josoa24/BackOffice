-- ============================================================
-- VERIFICATION TEST GLOBAL SPRINT 5 + 6 + 7
-- A executer APRES planification de la date 2026-03-27
-- ============================================================

-- 1) Vue globale des assignations du jour
SELECT a.id_assignation,
       TO_CHAR(a.heure_depart, 'HH24:MI') AS depart,
       TO_CHAR(a.heure_arrivee, 'HH24:MI') AS retour,
       r.id_client,
       r.nbPassager AS pax_reservation,
       a.nb_passagers_assignes AS pax_assignes,
       h.nom AS hotel,
       v.modele AS vehicule,
       v.capacite,
       v.carburant
FROM assignation a
JOIN reservation r ON r.id_reservation = a.id_reservation
JOIN hotel h ON h.id_hotel = COALESCE(a.id_hotel, r.id_hotel)
JOIN vehicule v ON v.id_vehicule = a.id_vehicule
WHERE DATE(a.heure_depart) = '2026-03-27'
ORDER BY a.heure_depart, r.id_client, a.id_assignation;

-- 2) Sprint 5: groupes de depart par hotel
SELECT COALESCE(a.id_hotel, r.id_hotel) AS id_hotel,
       h.nom AS hotel,
       TO_CHAR(a.heure_depart, 'HH24:MI') AS depart,
       COUNT(*) AS nb_lignes_assignation,
       SUM(a.nb_passagers_assignes) AS pax_assignes,
       STRING_AGG('C' || r.id_client::text || '(' || a.nb_passagers_assignes || ')', ', ' ORDER BY r.dateHeure, r.id_reservation) AS details
FROM assignation a
JOIN reservation r ON r.id_reservation = a.id_reservation
JOIN hotel h ON h.id_hotel = COALESCE(a.id_hotel, r.id_hotel)
WHERE DATE(a.heure_depart) = '2026-03-27'
GROUP BY COALESCE(a.id_hotel, r.id_hotel), h.nom, a.heure_depart
ORDER BY COALESCE(a.id_hotel, r.id_hotel), a.heure_depart;

-- Attendu Sprint 5 (hotel 2): departs a 08:30 puis 09:10

-- 3) Sprint 6: compteur de trajets effectues par vehicule
-- (inclut le trajet historique de 06:00 si present)
SELECT v.id_vehicule,
       v.modele,
       v.carburant,
       COUNT(DISTINCT a.heure_depart) AS nb_trajets
FROM vehicule v
LEFT JOIN assignation a
       ON a.id_vehicule = v.id_vehicule
      AND DATE(a.heure_depart) = '2026-03-27'
GROUP BY v.id_vehicule, v.modele, v.carburant
ORDER BY nb_trajets DESC, v.id_vehicule;

-- 4) Sprint 7: verifier split de reservations
-- Une reservation split a plusieurs lignes d'assignation sur la meme date
SELECT r.id_reservation,
       r.id_client,
       r.nbPassager AS pax_total,
       COUNT(a.id_assignation) AS nb_lignes,
       COALESCE(SUM(a.nb_passagers_assignes), 0) AS pax_assignes,
       r.nbPassager - COALESCE(SUM(a.nb_passagers_assignes), 0) AS pax_restants
FROM reservation r
LEFT JOIN assignation a
       ON a.id_reservation = r.id_reservation
      AND DATE(a.heure_depart) = '2026-03-27'
WHERE DATE(r.dateHeure) = '2026-03-27'
GROUP BY r.id_reservation, r.id_client, r.nbPassager
ORDER BY r.id_reservation;

-- Attendu Sprint 7:
-- - client 8102 (9 pax) doit avoir nb_lignes >= 2
-- - pax_restants = 0 apres planification complete

-- 5) Controle report vers groupe suivant (hotel 2)
-- Les reservations du groupe 08:30 peuvent se retrouver aussi a 09:10 si report
SELECT r.id_client,
       TO_CHAR(r.dateHeure, 'HH24:MI') AS heure_vol,
       STRING_AGG(DISTINCT TO_CHAR(a.heure_depart, 'HH24:MI'), ', ' ORDER BY TO_CHAR(a.heure_depart, 'HH24:MI')) AS departs_assignes,
       SUM(a.nb_passagers_assignes) AS pax_assignes_total
FROM reservation r
JOIN assignation a ON a.id_reservation = r.id_reservation
WHERE DATE(r.dateHeure) = '2026-03-27'
  AND COALESCE(a.id_hotel, r.id_hotel) = 2
GROUP BY r.id_client, r.dateHeure
ORDER BY r.dateHeure, r.id_client;

-- 6) Cas random Sprint 6 regle 4 (hotel 3, client 8301)
-- Relancer plusieurs fois le test complet pour observer alternativement Vehicule 1 / Vehicule 2
SELECT r.id_client,
       TO_CHAR(a.heure_depart, 'HH24:MI') AS depart,
       v.modele AS vehicule_choisi,
       v.carburant,
       v.capacite,
       a.nb_passagers_assignes
FROM assignation a
JOIN reservation r ON r.id_reservation = a.id_reservation
JOIN vehicule v ON v.id_vehicule = a.id_vehicule
WHERE DATE(a.heure_depart) = '2026-03-27'
  AND r.id_client = 8301;
