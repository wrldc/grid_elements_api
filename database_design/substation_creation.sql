START TRANSACTION READ WRITE;


SET @name = ?;


SET @description = ?;


SET @sil = 0;


SET @stabilityLimit = 0;


SET @thermalLimit = 0;


SET @typeName = "Substation";


SET @voltage = ?;


SET @ownerName = ?;


SET @ownerMetadata = "No_Metadata";


SET @ownerRegion = "NA";


SET @regionName0 = ?;


SET @regionName1 = ?;


SET @stateName0 = ?;


SET @stateName1 = ?;

INSERT INTO element_types (TYPE)
VALUES (@typeName)
ON DUPLICATE KEY
UPDATE TYPE = TYPE;


SET @typeId =
(SELECT id
 FROM element_types
 WHERE TYPE = @typeName);

INSERT INTO voltages (LEVEL)
VALUES (@voltage)
ON DUPLICATE KEY
UPDATE LEVEL = LEVEL;


SET @voltageId =
(SELECT id
 FROM voltages
 WHERE LEVEL = @voltage);

INSERT INTO elements (name, description, sil, stability_limit, thermal_limit, element_types_id, voltages_id)
VALUES (@name,
        @description,
        @sil,
        @stabilityLimit,
        @thermalLimit,
        @typeId,
        @voltageId)
ON DUPLICATE KEY
UPDATE name                             =
VALUES(name), description               =
VALUES(description), sil                =
VALUES(sil), stability_limit            =
VALUES(stability_limit), thermal_limit  =
VALUES(thermal_limit), element_types_id =
VALUES(element_types_id), voltages_id   =
VALUES(voltages_id);


SET @elementId =
(SELECT id
 FROM elements
 WHERE name = @name
       AND description = @description
       AND sil = @sil
       AND stability_limit = @stabilityLimit
       AND thermal_limit = @thermalLimit
       AND element_types_id = @typeId
       AND voltages_id = @voltageId);

INSERT INTO regions (name)
VALUES (@ownerRegion)
ON DUPLICATE KEY
UPDATE name = name;


SET @ownerRegionId =
(SELECT id
 FROM regions
 WHERE name = @ownerRegion);

INSERT INTO owners (name, metadata, regions_id)
VALUES (@ownerName,
        @ownerMetadata,
        @ownerRegionId)
ON DUPLICATE KEY
UPDATE name  = name,
  metadata   = metadata,
  regions_id = regions_id;


SET @ownerId =
(SELECT id
 FROM owners
 WHERE name = @ownerName);

INSERT INTO elements_has_owners (elements_id, owners_id)
VALUES (@elementId,
        @ownerId)
ON DUPLICATE KEY
UPDATE elements_id             =
VALUES(elements_id), owners_id =
VALUES(owners_id);

INSERT INTO regions (name)
VALUES (@regionName0)
ON DUPLICATE KEY
UPDATE name = name;


SET @elementRegionId =
(SELECT id
 FROM regions
 WHERE name = @regionName0);

INSERT INTO elements_has_regions (elements_id, regions_id)
VALUES (@elementId,
        @elementRegionId)
ON DUPLICATE KEY
UPDATE elements_id              =
VALUES(elements_id), regions_id =
VALUES(regions_id);

INSERT INTO regions (name)
VALUES (@regionName1)
ON DUPLICATE KEY
UPDATE name = name;


SET @elementRegionId =
(SELECT id
 FROM regions
 WHERE name = @regionName1);

INSERT INTO elements_has_regions (elements_id, regions_id)
VALUES (@elementId,
        @elementRegionId)
ON DUPLICATE KEY
UPDATE elements_id              =
VALUES(elements_id), regions_id =
VALUES(regions_id);

INSERT INTO states (name)
VALUES (@stateName0)
ON DUPLICATE KEY
UPDATE name = name;


SET @stateId =
(SELECT id
 FROM states
 WHERE name = @stateName0);

INSERT INTO elements_has_states (elements_id, states_id)
VALUES (@elementId,
        @stateId)
ON DUPLICATE KEY
UPDATE elements_id             =
VALUES(elements_id), states_id =
VALUES(states_id);

INSERT INTO states (name)
VALUES (@stateName1)
ON DUPLICATE KEY
UPDATE name = name;


SET @stateId =
(SELECT id
 FROM states
 WHERE name = @stateName1);

INSERT INTO elements_has_states (elements_id, states_id)
VALUES (@elementId,
        @stateId)
ON DUPLICATE KEY
UPDATE elements_id             =
VALUES(elements_id), states_id =
VALUES(states_id);

INSERT INTO substations (elements_id)
VALUES (@elementId)
ON DUPLICATE KEY
UPDATE elements_id =
VALUES(elements_id);


SET @substationId =
(SELECT id
 FROM substations
 WHERE elements_id = @elementId);

COMMIT;

SELECT @substationId AS substationId;