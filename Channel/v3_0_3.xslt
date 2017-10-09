<?xml version="1.0" encoding="UTF-8"?>
<!--
V3_0_3     - 08/10/2017 - EXTRACT:2 - Add Sending Extract 
				    - EXTRACT:1 - Suppress empty structures such as contact details.
				    - EXTRACT:3 - Implement CFRename template to support Observation -> ObservationCode rename
				    - EXTRACT:4 - Comments field in Allergy not being picked up due to field name differences. Rename implemented
				    - EXTRACT:5 - Implement CFRename template to support Facility -> FacilityCode rename for ClinicalRelationship
V3_0_2     - 07/04/2017 - 1] Restructure 0..8 ResultItem inside ResultItems wrapper. 2] correct dob and gender xpaths.
V3_0_0_5 - 17/02/2017 - Remove use of extensions due to unreliable behaviour
V3_0_0_4 - 19/01/2017 - Full use of CodedField and SimpleField templates making the transformation consistent in error behaviour and easier & less fragile to script
V3_0_0_3 - 18/01/2017 - Adds the CodedField Template
V3_0_0_2 - 18/01/2017 - Some rationalisation with simple CommonMetadata template
V3_0_0_1 - 18/01/2017 - Align full dataset with rationalised RDA
-->
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns:n1="http://www.rixg.org.uk/"
xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="n1 xs">
	<xsl:output method="xml" encoding="UTF-8" byte-order-mark="no" indent="yes"/>
	<xsl:template match="/">
		<xsl:variable name="patient" select="PatientDetails/Patient"/>
		<xsl:variable name="patientDetails" select="PatientDetails"/>

<n1:PatientRecord xmlns:n1="http://www.rixg.org.uk/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" >
<!--<xsl:attribute name="xsi:schemaLocation" namespace="xsi"
select="file:///C:/Users/user/Dropbox/Renal%20Registry/Schema%20Work/NJ%20UKRDC%20v1.01.xsd'"/>
-->
<xsl:attribute name="xsi:schemaLocation" namespace="http://www.w3.org/2001/XMLSchema-instance" select="'http://www.rixg.org.uk/ file:///C:/Users/Nick/Dropbox/Agiloak/Clients/Renal%20Registry/ukrdc/Schema/UKRDC.xsd'"/>

<!--
<n1:PatientRecord xmlns:n1="http://www.rixg.org.uk/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" 
xsi:schemaLocation="http://www.rixg.org.uk/ file:///C:/Users/user/Dropbox/Renal%20Registry/Schema%20Work/NJ%20UKRDC%20v1.01.xsd">
-->
			<SendingFacility>
				<xsl:attribute name="channelName"><xsl:value-of select="$patientDetails/@channelName" /></xsl:attribute>
				<xsl:attribute name="channelId"><xsl:value-of select="$patientDetails/@channelId" /></xsl:attribute>
				<xsl:attribute name="time"><xsl:value-of select="$patientDetails/@time" /></xsl:attribute>
				<xsl:value-of select="$patient/SendingFacility" />
			</SendingFacility>
			<SendingExtract>MIRTH</SendingExtract>
			<Patient>
				<PatientNumbers>
					<PatientNumber>
						<Number><xsl:value-of select="$patient/LocalPatientId" /></Number>
						<Organization>LOCALHOSP</Organization>
						<!--<Organization><xsl:value-of select="$patient/SendingFacility" /></Organization>-->
						<NumberType>MRN</NumberType>
					</PatientNumber>
					<xsl:for-each select="$patientDetails/PatientNumber">
						<PatientNumber>
							<Number><xsl:value-of select="./PatientId" /></Number>
							<Organization><xsl:value-of select="./Organization" /></Organization>
							<NumberType><xsl:value-of select="./NumberType" /></NumberType>
						</PatientNumber>
					</xsl:for-each>
				</PatientNumbers>
				<Names>
				<xsl:for-each select="$patientDetails/Name">
					<Name use="{./NameUse}">
						<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./Prefix"/></xsl:call-template>
						<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./Family"/></xsl:call-template>
						<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./Given"/></xsl:call-template>
						<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./Given2"/><xsl:with-param name="fname" select="'Given'"/></xsl:call-template>
						<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./Suffix"/></xsl:call-template>
					</Name>
				</xsl:for-each>
				</Names>
				<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="$patient/BirthTime"/></xsl:call-template>
				<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="$patient/Gender"/></xsl:call-template>
				<xsl:if test="$patientDetails/Address">
					<Addresses>
					<xsl:for-each select="$patientDetails/Address">
						<Address use="{./AddressUse}">
							<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./FromTime"/></xsl:call-template>
							<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./ToTime"/></xsl:call-template>
							<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./Street"/></xsl:call-template>
							<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./Town"/></xsl:call-template>
							<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./County"/></xsl:call-template>
							<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./Postcode"/></xsl:call-template>
							<!-- <xsl:call-template name="CodedField" ><xsl:with-param name="fld" select="./Country"/></xsl:call-template> -->
							<Country>
								<CodingStandard>ISO3166-1</CodingStandard>
								<Code><xsl:value-of select="./Country" /></Code>
							</Country>
						</Address>
					</xsl:for-each>
					</Addresses>
				</xsl:if>

				<xsl:if test="$patientDetails/ContactDetail">
				<ContactDetails>
				<xsl:for-each select="$patientDetails/ContactDetail">
					<ContactDetail use="{./ContactUse}">
					<!-- TODO: Defensive Coding around optional fields [General Comment] -->
							<Value><xsl:value-of select="./ContactValue" /></Value>
							<Comments><xsl:value-of select="./CommentText" /></Comments>
					</ContactDetail>
				</xsl:for-each>
				</ContactDetails>
				</xsl:if>

				<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="$patient/CountryOfBirth"/></xsl:call-template>
				<FamilyDoctor>
					<GPPracticeId><xsl:value-of select="$patient/FamilyDoctor_GPPracticeId" /></GPPracticeId>
					<GPId><xsl:value-of select="$patient/FamilyDoctor_GPId" /></GPId>
				</FamilyDoctor>

				<xsl:if test="$patient/PersonToContactName">
					<PersonToContact>
							<Name><xsl:value-of select="$patient/PersonToContactName" /></Name>
							<ContactDetails use="{$patient/PersonToContact_ContactNumberType}">
									<Value><xsl:value-of select="$patient/PersonToContact_ContactNumber" /></Value>
							</ContactDetails>
							<Relationship><xsl:value-of select="$patient/PersonToContact_Relationship" /></Relationship>
					</PersonToContact>
				</xsl:if>

				<EthnicGroup><Code><xsl:value-of select="$patient/EthnicGroup" /></Code></EthnicGroup>
				<Occupation><Code><xsl:value-of select="$patient/Occupation" /></Code></Occupation>
				<PrimaryLanguage><Code><xsl:value-of select="$patient/PatientLanguage" /></Code></PrimaryLanguage>
				<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="$patient/Death"/></xsl:call-template>
				<xsl:call-template name="CommonMetadata" />
			</Patient>
			
			<LabOrders>
				<xsl:attribute name="start"><xsl:value-of select="$patientDetails/@startDate" /></xsl:attribute>
				<xsl:attribute name="stop"><xsl:value-of select="$patientDetails/@endDate" /></xsl:attribute>
				<xsl:for-each select="$patientDetails/Order">
				<LabOrder>
					<xsl:variable name="placerId" select="./PlacerId"/>

					<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./PlacerId"/></xsl:call-template>
					<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./FillerId"/></xsl:call-template>

					<!-- DEFAULT Order Item for now
					<xsl:call-template name="CodedField" ><xsl:with-param name="fld" select="./OrderItem"/></xsl:call-template>-->
					<OrderItem>
						<CodingStandard>RENAL</CodingStandard>
						<Code>DEFAULT</Code>
						<Description>DEFAULT</Description>
					</OrderItem>

					<!-- DEFAULT Category for now 
					<xsl:call-template name="CodedField" ><xsl:with-param name="fld" select="./OrderCategory"/></xsl:call-template> -->
					<OrderCategory>
						<CodingStandard>RENAL</CodingStandard>
						<Code>DEFAULT</Code>
						<Description>DEFAULT</Description>
					</OrderCategory>

					<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./SpecimenCollectedTime"/></xsl:call-template>
					<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./SpecimenReceivedTime"/></xsl:call-template>

					<!-- Status and Priority are Defaulted in the extract. Required by HS but not available in the source
					<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./Status"/></xsl:call-template>
					<xsl:call-template name="CodedField" ><xsl:with-param name="fld" select="./Priority"/></xsl:call-template> -->
				    <Status>E</Status>
					<Priority>
						<Code>R</Code>
						<Description>R</Description>
					</Priority>

					<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./SpecimenSource"/></xsl:call-template>
					<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./Duration"/></xsl:call-template>
					
					<ResultItems>
					<xsl:for-each select="$patientDetails/ResultItem[PlacerId/text() = $placerId]">
						<ResultItem>
							<!-- Default in Result Type -->
							<ResultType>AT</ResultType>
							<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./EnteredOn"/></xsl:call-template>
							<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./PrePost"/></xsl:call-template>
							<xsl:call-template name="CodedField" ><xsl:with-param name="fld" select="./ServiceId"/></xsl:call-template>
							<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./ResultValue"/></xsl:call-template>
							<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./ResultValueUnits"/></xsl:call-template>
							<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./ReferenceRange"/></xsl:call-template>
							<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./AbnormalFlags"/></xsl:call-template>
							<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./Status"/></xsl:call-template>
							<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./ObservationTime"/></xsl:call-template>
							<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./CommentText"/><xsl:with-param name="fname" select="'Comments'"/></xsl:call-template>
							<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./ReferenceComment"/></xsl:call-template>
						</ResultItem>
					</xsl:for-each>
					</ResultItems>

					<xsl:call-template name="CodedField" ><xsl:with-param name="fld" select="./PatientClass"/></xsl:call-template>
					<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./EnteredOn"/></xsl:call-template>
					<xsl:call-template name="CodedField" ><xsl:with-param name="fld" select="./EnteredAt"/></xsl:call-template>
					<xsl:call-template name="CommonMetadata" />
				</LabOrder>
			</xsl:for-each>
			</LabOrders>

			<xsl:if test="$patientDetails/SocialHistory">
				<SocialHistories>
					<xsl:for-each select="$patientDetails/SocialHistory">
						<SocialHistory>
							<xsl:call-template name="CodedField" ><xsl:with-param name="fld" select="./SocialHabit"/></xsl:call-template>
							<xsl:call-template name="CommonMetadata" />
						</SocialHistory>
					</xsl:for-each>
				</SocialHistories>
			</xsl:if>
			
			<xsl:if test="$patientDetails/FamilyHistory">
				<FamilyHistories>
					<xsl:for-each select="$patientDetails/FamilyHistory">
						<FamilyHistory>
							<xsl:call-template name="CodedField" ><xsl:with-param name="fld" select="./FamilyMember"/></xsl:call-template>
							<xsl:call-template name="CodedField" ><xsl:with-param name="fld" select="./Diagnosis"/></xsl:call-template>
							<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./NoteText"/></xsl:call-template>
							<xsl:call-template name="CodedField" ><xsl:with-param name="fld" select="./EnteredAt"/></xsl:call-template>
							<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./FromTime"/></xsl:call-template>
							<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./ToTime"/></xsl:call-template>
							<xsl:call-template name="CommonMetadata" />
						</FamilyHistory>
					</xsl:for-each>
				</FamilyHistories>
			</xsl:if>
			
			<Observations>
				<xsl:attribute name="start"><xsl:value-of select="$patientDetails/@startDate" /></xsl:attribute>
				<xsl:attribute name="stop"><xsl:value-of select="$patientDetails/@endDate" /></xsl:attribute>
				<xsl:for-each select="$patientDetails/Observation">
					<Observation>
						<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./ObservationTime"/></xsl:call-template>
						<xsl:call-template name="CFRename" ><xsl:with-param name="fld" select="./Observation"/>
								<xsl:with-param name="fname" select="'ObservationCode'"/></xsl:call-template>
						<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./ObservationValue"/></xsl:call-template>
						<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./ObservationUnits"/></xsl:call-template>
						<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./Comments"/></xsl:call-template>
						<xsl:call-template name="CodedField" ><xsl:with-param name="fld" select="./Clinician"/></xsl:call-template>
						<xsl:call-template name="CommonMetadata" />
					</Observation>
				</xsl:for-each>
			</Observations>
			
			<xsl:if test="$patientDetails/Allergy">
				<Allergies>
					<xsl:for-each select="$patientDetails/Allergy">
						<Allergy>
							<xsl:call-template name="CodedField" ><xsl:with-param name="fld" select="./Allergy"/></xsl:call-template>
							<xsl:call-template name="CodedField" ><xsl:with-param name="fld" select="./AllergyCategory"/></xsl:call-template>
							<xsl:call-template name="CodedField" ><xsl:with-param name="fld" select="./Severity"/></xsl:call-template>
							<xsl:call-template name="CodedField" ><xsl:with-param name="fld" select="./Clinician"/></xsl:call-template>
							<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./DiscoveryTime"/></xsl:call-template>
							<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./ConfirmedTime"/></xsl:call-template>
							<xsl:call-template name="SimpleField" >
									<xsl:with-param name="fld" select="./CommentText"/>
									<xsl:with-param name="fname" select="'Comments'"/>
							</xsl:call-template>
							<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./InactiveTime"/></xsl:call-template>
							<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./FreeTextAllergy"/></xsl:call-template>
							<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./QualifyingDetails"/></xsl:call-template>
							<xsl:call-template name="CommonMetadata" />
						</Allergy>
					</xsl:for-each>
				</Allergies>
			</xsl:if>
			
			<xsl:if test="$patientDetails/Diagnosis or $patientDetails/CauseOfDeath or $patientDetails/RenalDiagnosis">
			<Diagnoses>
				<xsl:for-each select="$patientDetails/Diagnosis">
					<Diagnosis>
						<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./DiagnosisType"/></xsl:call-template>
						<xsl:call-template name="CodedField" ><xsl:with-param name="fld" select="./DiagnosingClinician"/></xsl:call-template>
						<xsl:call-template name="CodedField" ><xsl:with-param name="fld" select="./Diagnosis"/></xsl:call-template>
						<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./IdentificationTime"/></xsl:call-template>
						<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./OnsetTime"/></xsl:call-template>
						<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./EnteredOn"/></xsl:call-template>
						<xsl:call-template name="CommonMetadata" />
					</Diagnosis>
				</xsl:for-each>

				<xsl:for-each select="$patientDetails/CauseOfDeath">
					<CauseOfDeath>
						<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./DiagnosisType"/></xsl:call-template>
						<xsl:call-template name="CodedField" ><xsl:with-param name="fld" select="./DiagnosingClinician"/></xsl:call-template>
						<xsl:call-template name="CodedField" ><xsl:with-param name="fld" select="./Diagnosis"/></xsl:call-template>
						<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./EnteredOn"/></xsl:call-template>
						<xsl:call-template name="CommonMetadata" />
					</CauseOfDeath>
				</xsl:for-each>
				
				<xsl:for-each select="$patientDetails/RenalDiagnosis">
					<RenalDiagnosis>
						<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./DiagnosisType"/></xsl:call-template>
						<xsl:call-template name="CodedField" ><xsl:with-param name="fld" select="./DiagnosingClinician"/></xsl:call-template>
						<xsl:call-template name="CodedField" ><xsl:with-param name="fld" select="./Diagnosis"/></xsl:call-template>
						<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./IdentificationTime"/></xsl:call-template>
						<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./OnsetTime"/></xsl:call-template>
						<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./EnteredOn"/></xsl:call-template>
						<xsl:call-template name="CommonMetadata" />
					</RenalDiagnosis>
				</xsl:for-each>
			</Diagnoses>
			</xsl:if>

			<xsl:if test="$patientDetails/Medication">
				<Medications>
					<xsl:for-each select="$patientDetails/Medication">
						<Medication>
							<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./PrescriptionNumber"/></xsl:call-template>
							<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./FromTime"/></xsl:call-template>
							<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./ToTime"/></xsl:call-template>
							<xsl:call-template name="CodedField" ><xsl:with-param name="fld" select="./OrderedBy"/></xsl:call-template>
							<xsl:call-template name="CodedField" ><xsl:with-param name="fld" select="./Route"/></xsl:call-template>
							<!--  TODO tidy up Drug Product - Canonical form is flatter and so std template doesnt work-->
							<DrugProduct>
								<Id>
									<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./DrugProductId/CodeStd"/><xsl:with-param name="fname" select="'CodingStandard'"/></xsl:call-template>
									<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./DrugProductId/Code"/><xsl:with-param name="fname" select="'Code'"/></xsl:call-template>
									<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./DrugProductId/Desc"/><xsl:with-param name="fname" select="'Description'"/></xsl:call-template>
									<!--<CodingStandard><xsl:value-of select="./DrugProductIdCodeStd" /></CodingStandard>
									<Code><xsl:value-of select="./DrugProductIdCode" /></Code>
									<Description><xsl:value-of select="./DrugProductIdDesc" /></Description>-->
								</Id>
								<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./DrugProductGeneric"/><xsl:with-param name="fname" select="'Generic'"/></xsl:call-template>
								<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./DrugProductLabelName"/><xsl:with-param name="fname" select="'LabelName'"/></xsl:call-template>
								<Form>
									<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./DrugProductForm/CodeStd"/><xsl:with-param name="fname" select="'CodingStandard'"/></xsl:call-template>
									<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./DrugProductForm/Code"/><xsl:with-param name="fname" select="'Code'"/></xsl:call-template>
									<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./DrugProductForm/Desc"/><xsl:with-param name="fname" select="'Description'"/></xsl:call-template>
									<!--<CodingStandard><xsl:value-of select="./DrugProductFormStd" /></CodingStandard>
									<Code><xsl:value-of select="./DrugProductForm" /></Code>
									<Description><xsl:value-of select="./DrugProductIFormDesc" /></Description>-->
								</Form>
								<StrengthUnits>
									<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./DrugProductStrengthUnits/CodeStd"/><xsl:with-param name="fname" select="'CodingStandard'"/></xsl:call-template>
									<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./DrugProductStrengthUnits/Code"/><xsl:with-param name="fname" select="'Code'"/></xsl:call-template>
									<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./DrugProductStrengthUnits/Desc"/><xsl:with-param name="fname" select="'Description'"/></xsl:call-template>
									<!-- <CodingStandard><xsl:value-of select="./DrugProductStrengthUnitsCodeStd" /></CodingStandard>
									<Code><xsl:value-of select="./DrugProductStrengthUnitsCode" /></Code>
									<Description><xsl:value-of select="./DrugProductStrengthUnitsDesc" /></Description> -->
								</StrengthUnits>
							</DrugProduct>
							<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./Frequency"/></xsl:call-template>
							<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./Comments"/></xsl:call-template>
							<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./DoseQuantity"/></xsl:call-template>
							<xsl:call-template name="CodedField" ><xsl:with-param name="fld" select="./DoseUoM"/></xsl:call-template>
							<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./Indication"/></xsl:call-template>
							<xsl:call-template name="CommonMetadata" />
						</Medication>
					</xsl:for-each>
				</Medications>
			</xsl:if>
			
			<xsl:if test="$patientDetails/Procedure or $patientDetails/DialysisSession or $patientDetails/Transplant or $patientDetails/VascularAccess">
			<Procedures>
				<xsl:for-each select="$patientDetails/Procedure">
					<Procedure>
						<xsl:call-template name="CodedField" ><xsl:with-param name="fld" select="./ProcedureType"/></xsl:call-template>
						<xsl:call-template name="CodedField" ><xsl:with-param name="fld" select="./Clinician"/></xsl:call-template>
						<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./ProcedureTime"/></xsl:call-template>
						<xsl:call-template name="CodedField" ><xsl:with-param name="fld" select="./EnteredBy"/></xsl:call-template>
						<xsl:call-template name="CodedField" ><xsl:with-param name="fld" select="./EnteredAt"/></xsl:call-template>
						<xsl:call-template name="CommonMetadata" />
					</Procedure>
				</xsl:for-each>
				
				<xsl:for-each select="$patientDetails/DialysisSession">
					<DialysisSession>
						<xsl:attribute name="start"><xsl:value-of select="$patientDetails/@startDate" /></xsl:attribute>
						<xsl:attribute name="stop"><xsl:value-of select="$patientDetails/@endDate" /></xsl:attribute>

						<xsl:call-template name="CodedField" ><xsl:with-param name="fld" select="./ProcedureType"/></xsl:call-template>
						<xsl:call-template name="CodedField" ><xsl:with-param name="fld" select="./Clinician"/></xsl:call-template>
						<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./ProcedureTime"/></xsl:call-template>
						<xsl:call-template name="CodedField" ><xsl:with-param name="fld" select="./EnteredBy"/></xsl:call-template>
						<xsl:call-template name="CodedField" ><xsl:with-param name="fld" select="./EnteredAt"/></xsl:call-template>
						<xsl:call-template name="CommonMetadata" />
						<Attributes>
							<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./QHD19"/></xsl:call-template>
							<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./QHD20"/></xsl:call-template>
							<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./QHD21"/></xsl:call-template>
							<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./QHD22"/></xsl:call-template>
							<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./QHD30"/></xsl:call-template>
							<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./QHD31"/></xsl:call-template>
							<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./QHD32"/></xsl:call-template>
							<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./QHD33"/></xsl:call-template>
						</Attributes>
					</DialysisSession>
				</xsl:for-each>
				
				<xsl:for-each select="$patientDetails/Transplant">
					<Transplant>
						<xsl:call-template name="CodedField" ><xsl:with-param name="fld" select="./ProcedureType"/></xsl:call-template>
						<xsl:call-template name="CodedField" ><xsl:with-param name="fld" select="./Clinician"/></xsl:call-template>
						<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./ProcedureTime"/></xsl:call-template>
						<xsl:call-template name="CodedField" ><xsl:with-param name="fld" select="./EnteredBy"/></xsl:call-template>
						<xsl:call-template name="CodedField" ><xsl:with-param name="fld" select="./EnteredAt"/></xsl:call-template>
						<xsl:call-template name="CommonMetadata" />
						<Attributes>
							<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./TRA64"/></xsl:call-template>
							<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./TRA65"/></xsl:call-template>
							<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./TRA66"/></xsl:call-template>
							<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./TRA69"/></xsl:call-template>
							<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./TRA76"/></xsl:call-template>
							<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./TRA77"/></xsl:call-template>
							<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./TRA78"/></xsl:call-template>
							<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./TRA79"/></xsl:call-template>
							<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./TRA80"/></xsl:call-template>
							<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./TRA8A"/></xsl:call-template>
							<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./TRA81"/></xsl:call-template>
							<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./TRA82"/></xsl:call-template>
							<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./TRA83"/></xsl:call-template>
							<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./TRA84"/></xsl:call-template>
							<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./TRA85"/></xsl:call-template>
							<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./TRA86"/></xsl:call-template>
							<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./TRA87"/></xsl:call-template>
							<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./TRA88"/></xsl:call-template>
							<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./TRA89"/></xsl:call-template>
							<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./TRA90"/></xsl:call-template>
							<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./TRA91"/></xsl:call-template>
							<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./TRA92"/></xsl:call-template>
							<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./TRA93"/></xsl:call-template>
							<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./TRA94"/></xsl:call-template>
							<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./TRA95"/></xsl:call-template>
							<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./TRA96"/></xsl:call-template>
							<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./TRA97"/></xsl:call-template>
							<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./TRA98"/></xsl:call-template>
						</Attributes>
					</Transplant>
				</xsl:for-each>
				
				<xsl:for-each select="$patientDetails/VascularAccess">
					<VascularAccess>
						<xsl:call-template name="CodedField" ><xsl:with-param name="fld" select="./ProcedureType"/></xsl:call-template>
						<xsl:call-template name="CodedField" ><xsl:with-param name="fld" select="./Clinician"/></xsl:call-template>
						<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./ProcedureTime"/></xsl:call-template>
						<xsl:call-template name="CodedField" ><xsl:with-param name="fld" select="./EnteredBy"/></xsl:call-template>
						<xsl:call-template name="CodedField" ><xsl:with-param name="fld" select="./EnteredAt"/></xsl:call-template>
						<xsl:call-template name="CommonMetadata" />
						<Attributes>
							<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./ACC19"/></xsl:call-template>
							<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./ACC20"/></xsl:call-template>
							<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./ACC21"/></xsl:call-template>
							<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./ACC22"/></xsl:call-template>
							<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./ACC30"/></xsl:call-template>
							<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./ACC40"/></xsl:call-template>
						</Attributes>
					</VascularAccess>
				</xsl:for-each>
			</Procedures>
			</xsl:if>			
			<xsl:if test="$patientDetails/Document">
				<Documents>
					<xsl:for-each select="$patientDetails/Document">
						<Document>
							<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./DocumentTime"/></xsl:call-template>
							<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./NoteText"/></xsl:call-template>
							<xsl:call-template name="CodedField" ><xsl:with-param name="fld" select="./DocumentType"/></xsl:call-template>
							<xsl:call-template name="CodedField" ><xsl:with-param name="fld" select="./Clinician"/></xsl:call-template>
							<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./DocumentName"/></xsl:call-template>
							<xsl:call-template name="CodedField" ><xsl:with-param name="fld" select="./Status"/></xsl:call-template>
							<xsl:call-template name="CodedField" ><xsl:with-param name="fld" select="./EnteredBy"/></xsl:call-template>
							<xsl:call-template name="CodedField" ><xsl:with-param name="fld" select="./EnteredAt"/></xsl:call-template>
							<xsl:call-template name="CodedField" ><xsl:with-param name="fld" select="./FileType"/></xsl:call-template>
							<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./Stream"/></xsl:call-template>
							<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./DocumentURL"/></xsl:call-template>
							<xsl:call-template name="CommonMetadata" />
						</Document>
					</xsl:for-each>
				</Documents>
			</xsl:if>
			
			<xsl:if test="$patientDetails/Encounter or $patientDetails/Treatment or $patientDetails/TransplantList">
			<Encounters>
				<xsl:for-each select="$patientDetails/Encounter">
					<Encounter>
						<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./EncounterNumber"/></xsl:call-template>
						<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./EncounterType"/></xsl:call-template>
						<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./FromTime"/></xsl:call-template>
						<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./ToTime"/></xsl:call-template>
						<xsl:call-template name="CodedField" ><xsl:with-param name="fld" select="./AdmittingClinician"/></xsl:call-template>
						<xsl:call-template name="CodedField" ><xsl:with-param name="fld" select="./HealthCareFacility"/></xsl:call-template>
						<xsl:call-template name="CodedField" ><xsl:with-param name="fld" select="./AdmitReason"/></xsl:call-template>
						<xsl:call-template name="CodedField" ><xsl:with-param name="fld" select="./AdmissionSource"/></xsl:call-template>
						<xsl:call-template name="CodedField" ><xsl:with-param name="fld" select="./DischargeReason"/></xsl:call-template>
						<xsl:call-template name="CodedField" ><xsl:with-param name="fld" select="./DischargeLocation"/></xsl:call-template>
						<xsl:call-template name="CodedField" ><xsl:with-param name="fld" select="./EnteredAt"/></xsl:call-template>
						<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./VisitDescription"/></xsl:call-template>
						<xsl:call-template name="CommonMetadata" />
					</Encounter>
				</xsl:for-each>
				
				<xsl:for-each select="$patientDetails/Treatment">
					<Treatment>
						<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./EncounterNumber"/></xsl:call-template>
						<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./EncounterType"/></xsl:call-template>
						<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./FromTime"/></xsl:call-template>
						<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./ToTime"/></xsl:call-template>
						<xsl:call-template name="CodedField" ><xsl:with-param name="fld" select="./AdmittingClinician"/></xsl:call-template>
						<xsl:call-template name="CodedField" ><xsl:with-param name="fld" select="./HealthCareFacility"/></xsl:call-template>
						<xsl:call-template name="CodedField" ><xsl:with-param name="fld" select="./AdmitReason"/></xsl:call-template>
						<xsl:call-template name="CodedField" ><xsl:with-param name="fld" select="./AdmissionSource"/></xsl:call-template>
						<xsl:call-template name="CodedField" ><xsl:with-param name="fld" select="./DischargeReason"/></xsl:call-template>
						<xsl:call-template name="CodedField" ><xsl:with-param name="fld" select="./DischargeLocation"/></xsl:call-template>
						<xsl:call-template name="CodedField" ><xsl:with-param name="fld" select="./EnteredAt"/></xsl:call-template>
						<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./VisitDescription"/></xsl:call-template>
						<Attributes>
							<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./HDP01"/></xsl:call-template>
							<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./HDP02"/></xsl:call-template>
							<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./HDP03"/></xsl:call-template>
							<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./HDP04"/></xsl:call-template>
							<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./QBL05"/></xsl:call-template>
							<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./QBL06"/></xsl:call-template>
							<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./QBL07"/></xsl:call-template>
							<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./ERF61"/></xsl:call-template>
							<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./PAT35"/></xsl:call-template>
						</Attributes>
						<xsl:call-template name="CommonMetadata" />
					</Treatment>
				</xsl:for-each>
				
				<xsl:for-each select="$patientDetails/TransplantList">
					<TransplantList>
						<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./EncounterNumber"/></xsl:call-template>
						<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./EncounterType"/></xsl:call-template>
						<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./FromTime"/></xsl:call-template>
						<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./ToTime"/></xsl:call-template>
						<xsl:call-template name="CodedField" ><xsl:with-param name="fld" select="./AdmittingClinician"/></xsl:call-template>
						<xsl:call-template name="CodedField" ><xsl:with-param name="fld" select="./HealthCareFacility"/></xsl:call-template>
						<xsl:call-template name="CodedField" ><xsl:with-param name="fld" select="./AdmitReason"/></xsl:call-template>
						<xsl:call-template name="CodedField" ><xsl:with-param name="fld" select="./AdmissionSource"/></xsl:call-template>
						<xsl:call-template name="CodedField" ><xsl:with-param name="fld" select="./DischargeReason"/></xsl:call-template>
						<xsl:call-template name="CodedField" ><xsl:with-param name="fld" select="./DischargeLocation"/></xsl:call-template>
						<xsl:call-template name="CodedField" ><xsl:with-param name="fld" select="./EnteredAt"/></xsl:call-template>
						<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./VisitDescription"/></xsl:call-template>
						<xsl:call-template name="CommonMetadata" />
					</TransplantList>
				</xsl:for-each>
			</Encounters>
			</xsl:if>
			
			<xsl:if test="$patientDetails/ProgramMembership">
				<ProgramMemberships>
					<xsl:for-each select="$patientDetails/ProgramMembership">
						<ProgramMembership>
							<xsl:call-template name="CodedField" ><xsl:with-param name="fld" select="./EnteredBy"/></xsl:call-template>
							<xsl:call-template name="CodedField" ><xsl:with-param name="fld" select="./EnteredAt"/></xsl:call-template>
							<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./ProgramName"/></xsl:call-template>
							<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./ProgramDescription"/></xsl:call-template>
							<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./FromTime"/></xsl:call-template>
							<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./ToTime"/></xsl:call-template>
							<xsl:call-template name="CommonMetadata" />
						</ProgramMembership>
					</xsl:for-each>
				</ProgramMemberships>
			</xsl:if>
			
			<xsl:if test="$patientDetails/ClinicalRelationship">
				<ClinicalRelationships>
					<xsl:for-each select="$patientDetails/ClinicalRelationship">
						<ClinicalRelationship>
							<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./FromTime"/></xsl:call-template>
							<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./ToTime"/></xsl:call-template>
							<xsl:call-template name="CodedField" ><xsl:with-param name="fld" select="./Clinician"/></xsl:call-template>
							<xsl:call-template name="CFRename" >
								<xsl:with-param name="fld" select="./Facility"/>
								<xsl:with-param name="fname" select="'FacilityCode'"/>
							</xsl:call-template>
							<xsl:call-template name="CommonMetadata" />
						</ClinicalRelationship>
					</xsl:for-each>
				</ClinicalRelationships>
			</xsl:if>

			<xsl:if test="$patientDetails/Survey">
				<Surveys>
					<xsl:for-each select="$patientDetails/Survey">
						<Survey>
							<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./SurveyTime"/></xsl:call-template>
							<xsl:call-template name="CodedField" ><xsl:with-param name="fld" select="./SurveyType"/></xsl:call-template>
							<Questions></Questions>
							<Scores></Scores>
							<xsl:call-template name="CodedField" ><xsl:with-param name="fld" select="./EnteredBy"/></xsl:call-template>
							<xsl:call-template name="CodedField" ><xsl:with-param name="fld" select="./EnteredAt"/></xsl:call-template>
							<xsl:call-template name="CommonMetadata" />
						</Survey>
					</xsl:for-each>
				</Surveys>
			</xsl:if>
			
		</n1:PatientRecord>
	</xsl:template>

	<xsl:template name="CommonMetadata">
		<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./UpdatedOn"/></xsl:call-template>
		<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./ActionCode"/></xsl:call-template>
		<xsl:call-template name="SimpleField" ><xsl:with-param name="fld" select="./ExternalId"/></xsl:call-template>
	</xsl:template>
	
	<xsl:template match="*" mode="CodedField">
		<xsl:copy>
			<xsl:if test="./CodeStd">
				<CodingStandard><xsl:value-of select="./CodeStd" /></CodingStandard>
			</xsl:if>
			<xsl:if test="./Code">
				<Code><xsl:value-of select="./Code" /></Code>
			</xsl:if>
			<xsl:if test="./Desc">
				<Description><xsl:value-of select="./Desc" /></Description>
			</xsl:if>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template name="CodedField">
		<xsl:param name="fld"/>
		<xsl:apply-templates mode="CodedField" select="$fld"/>
	</xsl:template>
	
	<xsl:template name="CFRename">
		<xsl:param name="fld"/>
		<xsl:param name="fname"/>
		<xsl:element name="{$fname}">
			<xsl:if test="$fld/CodeStd">
				<CodingStandard><xsl:value-of select="$fld/CodeStd" /></CodingStandard>
			</xsl:if>
			<xsl:if test="$fld/Code">
				<Code><xsl:value-of select="$fld/Code" /></Code>
			</xsl:if>
			<xsl:if test="$fld/Desc">
				<Description><xsl:value-of select="$fld/Desc" /></Description>
			</xsl:if>
		</xsl:element>
	</xsl:template>

	<xsl:template name="SimpleField">
		<xsl:param name="fld"/>
		<xsl:param name="fname"/>
		<xsl:choose>
			<xsl:when test="$fname">
				<xsl:if test="$fld">
					<xsl:element name="{$fname}">
						<xsl:value-of select="$fld" />
					</xsl:element>
				</xsl:if>
			</xsl:when>
			<xsl:otherwise>
			    <xsl:copy-of select="$fld" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
</xsl:stylesheet>