Use openmrs;
SET @row_number = 0;
SELECT CASE WHEN COUNT(othervisit.visit_id)> 0  THEN '' ELSE '*' END AS `HUDHURIO LA KWANZA`,
 (@row_number:=@row_number + 1) AS NAMBA,
v.date_started AS TAREHE,
CONCAT(YEAR(v.date_started),'/',(@row_number:=@row_number + 1)) AS `NAMBA YA HUDHURIO`,
CONCAT(pn.given_name,' ',pn.family_name) AS `JINA LA MGONJWA`,
pa.address1 AS `MAHALI ANAISHI`,
DATE_FORMAT(FROM_DAYS(DATEDIFF(v.date_started, p.birthdate)), '%Y') + 0 AS UMRI,
GROUP_CONCAT(DISTINCT CASE WHEN p.gender='M' THEN 'Me'  ELSE 'Ke' END) AS `JINSIA YA MGONJWA`,
GROUP_CONCAT(DISTINCT CASE WHEN ob2.concept_id='165861' THEN ob2.value_numeric  ELSE null END) AS `UZITO(kg)`,
GROUP_CONCAT(DISTINCT CASE WHEN ob2.concept_id='165860' THEN ob2.value_numeric  ELSE null END) AS `UREFU(cm)`,
GROUP_CONCAT(DISTINCT CASE WHEN ot.name='Test Order' THEN test_order_concept_name.name ELSE NULL END) AS `VIPIMO`,
GROUP_CONCAT(DISTINCT CASE WHEN test_result_concept_name.name IS NULL THEN ob.value_text ELSE test_result_concept_name.name END)AS `MATOKEO YA VIPIMO`,
GROUP_CONCAT(DISTINCT CASE WHEN ed.certainty='CONFIRMED' THEN diagnosis_concept_name.name ELSE NULL END) AS DIAGNOSIS,
GROUP_CONCAT(DISTINCT d.name) AS `MATIBABU`,
GROUP_CONCAT(DISTINCT result_encounter_type.name) AS `MATOKEO YA MAHUDHURIO`,
GROUP_CONCAT(DISTINCT CASE WHEN vat.name='PaymentCategory' THEN payment_concept_name.name ELSE NULL END)AS `MALIPO`

from visit v

-- Addressing names and address
LEFT JOIN person p ON p.person_id=v.patient_id
LEFT JOIN person_name pn ON p.person_id=pn.person_id
LEFT JOIN person_address pa ON p.person_id=pa.person_id

-- Addressing hudhuriao la kwanza
LEFT JOIN visit othervisit ON p.person_id=othervisit.patient_id
AND othervisit.visit_id <> v.visit_id AND othervisit.date_started < v.date_started  AND YEAR(othervisit.date_started)=YEAR(v.date_started)

-- Addressing vipimo vilivyoagizwa
LEFT JOIN encounter test_order_encounter ON test_order_encounter.visit_id=v.visit_id
LEFT JOIN orders test_order_order ON test_order_order.encounter_id=test_order_encounter.encounter_id
LEFT JOIN order_type ot ON ot.order_type_id=test_order_order.order_type_id
LEFT JOIN concept test_order_concept ON test_order_concept.concept_id=test_order_order.concept_id
LEFT JOIN concept_name test_order_concept_name ON test_order_concept_name.concept_id=test_order_concept.concept_id AND test_order_concept_name.concept_name_type='FULLY_SPECIFIED'

-- Addressing Matokeo ya vipimo
LEFT JOIN obs ob ON ob.order_id=test_order_order.order_id
LEFT JOIN concept_name test_result_concept_name ON test_result_concept_name.concept_id=ob.value_coded AND test_result_concept_name.concept_name_type = 'FULLY_SPECIFIED'

-- Addressing other vitals obs
 LEFT JOIN obs ob2 ON ob2.encounter_id=test_order_encounter.encounter_id

-- Addressing Diagnosis
LEFT JOIN encounter diagnosis_encounter ON diagnosis_encounter.visit_id=v.visit_id
LEFT JOIN encounter_diagnosis ed ON ed.encounter_id=diagnosis_encounter.encounter_id
LEFT JOIN concept diagnosis_concept ON ed.diagnosis_coded=diagnosis_concept.concept_id
LEFT JOIN concept_name diagnosis_concept_name ON diagnosis_concept_name.concept_id=diagnosis_concept.concept_id

-- Addressing Matibabu
LEFT JOIN drug_order do ON do.order_id=test_order_order.order_id
LEFT JOIN drug d ON d.drug_id=do.drug_inventory_id

-- MATOKEO
-- LEFT JOIN encounter result_encounter ON result_encounter.visit_id=v.visit_id
LEFT JOIN encounter_type result_encounter_type ON diagnosis_encounter.encounter_type=result_encounter_type.encounter_type_id
AND (result_encounter_type.encounter_type_id =1 OR result_encounter_type.encounter_type_id =2 OR result_encounter_type.encounter_type_id =22)

-- MALIPO
LEFT JOIN visit_attribute va ON va.visit_id = v.visit_id
LEFT JOIN visit_attribute_type vat ON va.attribute_type_id=vat.visit_attribute_type_id
LEFT JOIN concept visit_attribute_concept ON va.value_reference=visit_attribute_concept.uuid
LEFT JOIN concept_name payment_concept_name ON payment_concept_name.concept_id=visit_attribute_concept.concept_id


-- WHERE v.uuid='15eb0b9a-f1bf-4333-8c3f-28de3ae19866'
-- ADDRESSING VISIT TYPE
LEFT JOIN visit_type vt ON vt.visit_type_id=v.visit_type_id

WHERE vt.name='OPD' AND (v.date_started BETWEEN '2022-04-10' AND '2022-09-12')
GROUP BY v.date_started,CONCAT(pn.given_name,' ',pn.family_name),pa.address1,v.uuid
ORDER BY v.date_started ASC
