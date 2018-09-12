<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xmlns:fo="http://www.w3.org/1999/XSL/Format"
				xmlns:n1="urn:hl7-org:v3"
				xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
    
    <!--
    
    	Organisation: MEDYS GmbH, Wülfrath
    	
    	Author: Hayri Emrah Kayaman
    	
    	Jahr: 2015
    	
    	Projekt: eArztbrief
    
    	Version: 1.0
    -->
    
    <!-- ===========   Seitestruktur: Vorbereitungen und STARTUP ===================   -->
	
	<xsl:template match="/">
		
		<fo:root font-family="Arial" font-size="12pt">
		
			<!-- Seiten haben A4-Format -->
			<fo:layout-master-set>
				
				<!-- Masterschablone für Seite 1 -->
				<fo:simple-page-master 	master-name="Seite1"
										page-height="29.7cm"
										page-width="21cm"
										margin-top="1cm"
										margin-left="1.2cm"
										margin-right="1cm"
										margin-bottom="1cm">
					
					<!-- Seiteninhaltsbereich -->
					<fo:region-body 	margin-top="8.7cm"
										margin-left="1cm"
										margin-right="0.1cm"
										margin-bottom="0.8cm"/>
					
					<!-- Kopfzeile -->					
					<fo:region-before 	region-name="kopfzeile"
										extent="8.7cm"/>
					
					<!-- Fußzeile -->
					<fo:region-after 	region-name="fusszeile"
										margin-top="0.5cm"
										extent="0.4cm"/>
					
					<!-- Seitenrand Links -->
					<fo:region-start 	region-name="linkerSeitenrand"
										extent="1cm"/>
					
					<!-- Seitenrand Rechts -->
					<fo:region-end 		region-name="rechterSeitenrand"
										extent="0.1cm"/>
					
				</fo:simple-page-master>
				
				<!-- Masterschablone für Folgeseiten -->
				<fo:simple-page-master 	master-name="naechsteSeite"
										page-height="29.7cm"
										page-width="21cm"
										margin-top="1cm"
										margin-left="1.2cm"
										margin-right="1cm"
										margin-bottom="1cm">
					
					<!-- Seiteninhaltsbereich -->
					<fo:region-body 	margin-top="0.5cm"
										margin-left="1cm"
										margin-right="0.1cm"
										margin-bottom="1cm"/>
					
					<!-- Fußzeile -->
					<fo:region-after 	region-name="fusszeile"
										extent="0.5cm"/>
					
					<!-- Seitenrand Links -->
					<fo:region-start 	extent="1cm"/>
					
					<!-- Seitenrand Rechts -->
					<fo:region-end 		extent="0.1cm"/>
					
				</fo:simple-page-master>
				
				<!-- Reihenfolge der Seiten festlegen -->
				
				<fo:page-sequence-master master-name="inhalte">
				
					<fo:repeatable-page-master-alternatives>
					
						<fo:conditional-page-master-reference master-reference="Seite1" page-position="first" odd-or-even="odd"/>
						
						<fo:conditional-page-master-reference master-reference="naechsteSeite" page-position="rest"/>
						
					</fo:repeatable-page-master-alternatives>
					
				</fo:page-sequence-master>
				
			</fo:layout-master-set>
			
			<!-- Reihenfolge der Seiten festlegen -->
				
			<fo:page-sequence master-reference="inhalte">
				
				<fo:static-content flow-name="kopfzeile" font-size="10pt">
					
					<fo:table table-layout="fixed" width="100%">
					
						<fo:table-body>
						
							<fo:table-row>
							
								<fo:table-cell>
									<fo:block>
										<xsl:apply-templates select="/n1:ClinicalDocument/n1:author"/>
									</fo:block>
								</fo:table-cell>
								
								
								<xsl:if test="/n1:ClinicalDocument/n1:informationRecipient">
								
									<fo:table-cell>
										<fo:block>
											<xsl:apply-templates select="/n1:ClinicalDocument/n1:informationRecipient"/>
										</fo:block>
									</fo:table-cell>
								
								</xsl:if>
								
							</fo:table-row>	
							
						</fo:table-body>
						
					</fo:table>
					
					<xsl:apply-templates select="/n1:ClinicalDocument/n1:recordTarget"/>
					
					
				</fo:static-content>
				
				<fo:static-content flow-name="fusszeile" font-size="9pt">
			
					<fo:block text-align="right">
				
						Seite <fo:page-number/> von <fo:page-number-citation ref-id="LastPage"/>
					
					</fo:block>
				
				</fo:static-content>
				
				<fo:flow flow-name="xsl-region-body" font-size="10pt">
				
					
					<!-- Dokumentinhalt -->
					
					<xsl:apply-templates select="n1:ClinicalDocument"/>
					
					<!-- Von-Seite-Angabe -->
					<fo:block id="LastPage"/>
					
				</fo:flow>
				
			</fo:page-sequence>
			
		</fo:root>
		
	</xsl:template>
	
	
	<!-- =======================    Ordnung / Strukturierung   =====================   -->
	
	<xsl:template name="horizontaleLinie">
	
		<fo:block text-align="center" space-before="2pt" space-after="6pt">
		
			<fo:leader leader-length="100%" leader-pattern="rule" rule-thickness="0.8pt" color="black"></fo:leader>
			
		</fo:block>
		
	</xsl:template>


    <!-- ========================= effectiveTime - Datum ===========================   -->
    
    <xsl:template match="n1:effectiveTime">
    
    	<xsl:variable name="varDatum" select="@value"/>
    	
    	<xsl:variable name="varTag" 	select="substring($varDatum,7,2)"/>
    	<xsl:variable name="varMonat"	select="substring($varDatum,5,2)"/>
    	<xsl:variable name="varJahr"	select="substring($varDatum,1,4)"/>
    	
    	<fo:block font-size="8pt">
    		<xsl:value-of select="concat($varTag,'&#46;',$varMonat,'&#46;',$varJahr)"/>
    	</fo:block>
    	
    	
    </xsl:template>
    
    
    <!-- ===================== Telekommunikationsangaben ===========================  --> 
    	 
    <xsl:template match="n1:telecom">
    
    	<xsl:choose>
    	
    		<xsl:when test="contains(@value,'tel:')">
    		
    			<fo:block>
    				Telefon  <xsl:value-of select="substring-after(@value,'tel:')"/>
    			</fo:block>
    			
    		</xsl:when>
    		
    		<xsl:when test="contains(@value,'fax:')">
    		
    			<fo:block>
    				Fax  <xsl:value-of select="substring-after(@value,'fax:')"/>
    			</fo:block>
    			
    		</xsl:when>
    		
    	</xsl:choose>
    	
    </xsl:template>
    
    
    <!-- ===============  Adressangaben ohne Telekommunikationsangaben =============   -->
    
    <xsl:template match="n1:addr">
    
    	<fo:table-row>
    		<fo:table-cell>
    			<fo:block>
    				<xsl:value-of select="concat(n1:streetName,' ',n1:houseNumber)"/>
    			</fo:block>
    		</fo:table-cell>
    	</fo:table-row>
    	
    	<fo:table-row>
    		<fo:table-cell>
    			<fo:block>
     				<xsl:value-of select="n1:postalCode"/>
     			</fo:block>
     		</fo:table-cell>
    	</fo:table-row>
    	
    	<fo:table-row>
    		<fo:table-cell>
    			<fo:block>
    				<xsl:value-of select="n1:city"/>
    			</fo:block>
    		</fo:table-cell>
    	</fo:table-row>
    	
    	<fo:table-row>
    		<fo:table-cell>
    			<fo:block>
    				<xsl:value-of select="n1:country"/>
    			</fo:block>
    		</fo:table-cell>
    	</fo:table-row>
 
	</xsl:template>
   	
    <!-- =========================   Personen-/Firmenname     ======================   -->    
    
    <xsl:template match="n1:name">
    
    	<xsl:variable name="varPersonTitel" select="n1:prefix"/>
    	<xsl:variable name="varVorname" 	select="n1:given"/>
    	<xsl:variable name="varNachname" 	select="n1:family"/>
    	
    	<xsl:variable name="varZusammengesetzterName">
    		<xsl:value-of select="concat($varVorname,' ',$varNachname)"/>
    	</xsl:variable>
    	
    	<xsl:variable name="varNameMitTitel">
    		<xsl:value-of select="concat($varPersonTitel,' ',$varZusammengesetzterName)"/> 
    	</xsl:variable>
    	
    	
    	<fo:table-row>
    		<fo:table-cell>
    			<fo:block>
    			   	<xsl:choose>
    		
    					<xsl:when test="string-length($varPersonTitel) &gt; 0">
   		 					<xsl:choose>
   		 					
   		 						<xsl:when test="(string-length($varVorname) &gt; 0) or (string-length($varNachname) &gt; 0)">
   		 							<xsl:value-of select="$varNameMitTitel"/>
    							</xsl:when>
    							
    						</xsl:choose>
  	  					</xsl:when>
  	  					
  	  					<xsl:when test="(string-length($varPersonTitel)=0) and ((string-length($varVorname) &gt; 0) or (string-length($varNachname) &gt; 0))">
  	  						<xsl:value-of select="$varZusammengesetzterName"/>
  	  					</xsl:when>
  	  					
  	  					
  	  					<!-- 
  	  						Elemente sind nicht vorhanden, dann ist NAME-Element ein Name einer Firma/Praxis
  	  					-->
  	  					<xsl:when test="not(n1:prefix)">
  	  						<xsl:value-of select="."/>
  	  					</xsl:when>
  	  					
  	  				</xsl:choose>
    				
    			</fo:block>
    		</fo:table-cell>
    	</fo:table-row>
    	
    </xsl:template>
    
    
    <!-- ========================== Geschlecht/Anrede ==============================   -->
    	
    <xsl:template match="n1:administrativeGenderCode">
    	
    	<xsl:variable name="varGeschlecht" select="@code"/>
    	
    	<xsl:variable name="varMaennlich">
    		<fo:block>männlich</fo:block>
    	</xsl:variable>
    	
    	<xsl:variable name="varWeiblich">
    		<fo:block>weiblich</fo:block>
    	</xsl:variable>
    	
    	<xsl:variable name="varUnbekannt">
    		<fo:block>Geschlecht unbekannt</fo:block>
    	</xsl:variable>
    	
    	<xsl:choose>
    	
   			<xsl:when test="$varGeschlecht='M'">
   				<xsl:value-of select="$varMaennlich"/>
   			</xsl:when>
   			
   			<xsl:when test="$varGeschlecht='F'">
   				<xsl:value-of select="$varWeiblich"/>
   			</xsl:when>
   			
   			<xsl:when test="$varGeschlecht='U'">
   				<xsl:value-of select="$varUnbekannt"/>
   			</xsl:when>
   			
   			<xsl:when test="$varGeschlecht='m'">
   				<xsl:value-of select="$varMaennlich"/>
   			</xsl:when>
   			
   			<xsl:when test="$varGeschlecht='f'">
   				<xsl:value-of select="$varWeiblich"/>
   			</xsl:when>
   			
   			<xsl:when test="$varGeschlecht='u'">
   				<xsl:value-of select="$varUnbekannt"/>
   			</xsl:when>
   			
   		</xsl:choose>
   		
    </xsl:template>
    
    
    <!-- ========================== Person-Geburtstag ==============================   -->
    
    <xsl:template match="n1:birthTime">
    	
    	<xsl:variable name="varDatum" select="@value"/>
    	
    	<xsl:variable name="varTag" 	select="substring($varDatum,7,2)"/>
    	<xsl:variable name="varMonat" 	select="substring($varDatum,5,2)"/>
    	<xsl:variable name="varJahr" 	select="substring($varDatum,1,4)"/>
    	
    	<fo:block>
    		<xsl:value-of select="concat($varTag,'&#46;',$varMonat,'&#46;',$varJahr)"/>
    	</fo:block>
    	
    </xsl:template>
    	
	   
    <!-- =================== InformationRecipient ==================================   -->
    
    <!-- Template: ClinicalDocument.informationRecipient -->
    
    <xsl:template match="n1:informationRecipient">
    	<xsl:choose>
    		<xsl:when test="not(n1:intendedRecipient)">
    			<xsl:apply-templates select="n1:name"/>
    		</xsl:when>
    		<xsl:when test="not(n1:name)">
    			<xsl:apply-templates select="n1:intendedRecipient"/>
    		</xsl:when>
    	</xsl:choose>
   	</xsl:template>
    
    <!-- Template: ClinicalDocument.informationRecipient.intendendRecipient -->
    
    <xsl:template match="n1:intendedRecipient">
    	
    	<fo:table table-layout="fixed" width="100%">
    	
    		<fo:table-header>
    		
    			<fo:table-row>
    			
    				<fo:table-cell>
    				
    					<fo:block margin-bottom="0.3cm" font-weight="bold" text-decoration="underline">
    					An:
    					</fo:block>
    					
    				</fo:table-cell>
    				
    			</fo:table-row>
    			
    		</fo:table-header>
    		
   	 		<fo:table-body>
   	 		
    			<xsl:apply-templates select="n1:informationRecipient"/>
    			
    			<xsl:if test="n1:receivedOrganization">
   					<xsl:apply-templates select="n1:receivedOrganization"/>
   				</xsl:if>
   				
   			</fo:table-body>  
   		</fo:table>
    	
    </xsl:template>
    
    <!-- Template: ClinicalDocument.informationRecipient.receivedOrganization -->
    
    <xsl:template match="n1:receivedOrganization">
    
    	<xsl:apply-templates select="n1:addr"/>		<!-- behandelt table-row-cell -->
    	
    	<fo:table-row>
    	
    		<fo:table-cell>
    		
    			<fo:block margin-top="0.3cm">
    	    		<xsl:apply-templates select="n1:telecom"/>		
	        	</fo:block>
	        	
	        </fo:table-cell>
	        
	    </fo:table-row>
	    
    </xsl:template>
    
    
    <!-- Template: ClinicalDocument.informationRecipient.receivedOrganization -->
    
    <xsl:template match="n1:receivedOrganization">
    
    	
    	<xsl:apply-templates select="n1:addr"/>		behandelt table-row-cell
    	
    	<fo:table-row>
    		<fo:table-cell>
    		
    			<fo:block margin-top="0.3cm">
    	    		<xsl:apply-templates select="n1:telecom"/>		
	        	</fo:block>
	        	
	        </fo:table-cell>
	    </fo:table-row>
	    
    </xsl:template>
    
    
    <!-- ===============  	Author des ClinicalDocument 	   =====================   -->
    
    <!-- Template: ClinicalDocument.author  -->
    
    <xsl:template match="n1:author"> 
    	<xsl:apply-templates select="n1:assignedAuthor"/>
    </xsl:template>
    
    
    <!-- Template: ClinicalDocument.author.assignedAuthor -->
    
    <xsl:template match="n1:assignedAuthor">
    	<fo:table table-layout="fixed" width="100%">
    		<fo:table-header>
    			<fo:table-row>
    				<fo:table-cell>
    					
    					<fo:block margin-bottom="0.3cm" font-weight="bold" text-decoration="underline">
    					Von:
    					</fo:block>
    					
    				</fo:table-cell>
    			</fo:table-row>
    		</fo:table-header>
    		<fo:table-body>
    		
    			<xsl:apply-templates select="n1:assignedPerson"/>
    			
    			<xsl:apply-templates select="n1:representedOrganization"/>
    			
    		</fo:table-body>
    	</fo:table>
    	
    </xsl:template>
    
    <!-- Template: ClinicalDocument.author.assignedAuthor.assignedPerson -->
    
    <xsl:template match="n1:assignedPerson">
    	<xsl:apply-templates select="n1:name"/>
    </xsl:template>
    
    <!-- Template: ClinicalDocument.author.assignedAuthor.representedOrganization -->
    
    <xsl:template match="n1:representedOrganization">
    
    	<xsl:apply-templates select="n1:name"/>
        <xsl:apply-templates select="n1:addr"/> 		<!-- behandelt table-row-cell -->
        
        <fo:table-row>
        	<fo:table-cell>
    			
    			<fo:block margin-top="0.3cm">
    	    		<xsl:apply-templates select="n1:telecom"/>		
	        	</fo:block>
	        	
	        </fo:table-cell>
	    </fo:table-row>

    </xsl:template>
    
    
    <!-- ===============  		RecordTarget/Patient		========================   -->
    
    <!-- Template: ClinicalDocument.recordTarget.patientRole.patient -->
    
    <xsl:template match="n1:patient">
    
    	<!--
    	 Anrede kommt nicht in eArztbrief.xml vor. 
    	
    	Anrede wird on-the-fly in das Ausgabeformat als neues XML-Element erzeugt.
    	Der Inhalt der Anrede ist dannd die Anrede der Person passend zu seinem Geschlecht
  		-->
  		
  		<xsl:variable name="varAnredeGeschlecht">
  			<xsl:value-of select="n1:administrativeGenderCode/@code"/>
  		</xsl:variable>
  		
    	<xsl:variable name="varPersonAnrede">
 			<xsl:choose>
 			
				<xsl:when test="$varAnredeGeschlecht='m'">
					<xsl:text>Herr</xsl:text>
				</xsl:when>
				
				<xsl:when test="$varAnredeGeschlecht='f'">
 					<xsl:text>Frau</xsl:text>
	 			</xsl:when>
	 			
				<xsl:when test="$varAnredeGeschlecht='M'">
					<xsl:text>Herr</xsl:text>
				</xsl:when>
				
				<xsl:when test="$varAnredeGeschlecht='F'">
					<xsl:text>Frau</xsl:text>
				</xsl:when>
				
			</xsl:choose>  
  		</xsl:variable>
  		
    	<xsl:variable name="varPersonName">
    		<xsl:apply-templates select="n1:name"/>
    	</xsl:variable>
    	
    	<!-- Ausgabe des Gechlechts inkl. des Geburtstags -->
    		
    	<xsl:variable name="varGeburtstag">
    		<xsl:apply-templates select="n1:birthTime"/>
    	</xsl:variable>
    	
    	<!-- Tabellenzeile für Anrede, Vorname, Nachname , Geburtsdaten
    	-->
    	<fo:table-row>
    	
    		<fo:table-cell>
    		
	    		<fo:block margin-top="0.3cm">
    				<xsl:value-of select="concat($varPersonAnrede,' ',$varPersonName,' &#40;* ',$varGeburtstag,'&#41;')"/>
    			</fo:block>	
    			
    		</fo:table-cell>
    		
    	</fo:table-row>
    	
    	<!-- Tabellenzeile für die Adressdaten (strukturiert intern mit <fo:table-row> )
    	-->
    	<xsl:apply-templates select="../n1:addr"/> 
    	
    </xsl:template>  
    
    
    <!-- Template: ClinicalDocument.recordTarget -->
    
    <xsl:template match="n1:recordTarget">
    	
    	<fo:block keep-together="always">
    	
    		<fo:table table-layout="fixed" width="100%" margin-top="0.5cm">
    		
    			<fo:table-header>
    			
    				<fo:table-row>
    				
    					<fo:table-cell font-weight="bold" text-decoration="underline">
    				
       						<fo:block>
       							Patient
       						</fo:block>
       					
      	 				</fo:table-cell>
      	 				
      	 			</fo:table-row>
      	 			
    			</fo:table-header>
    		
    			<fo:table-body>
    			
        			<xsl:apply-templates select="n1:patientRole/n1:patient"/>
        			
       		 	</fo:table-body>
       		 	
    		</fo:table>
    		
    	</fo:block>
    	
    </xsl:template>
    
    
    <!-- ===============     ClinicalDocument - Textinhalt    ======================   -->
    
    <!--          global Variablen              -->
    
    <!-- Überschrift oder Titel : Bereich = Betreff -->
	
    <xsl:variable name="glbVarEarztbriefTitel">
        <xsl:choose>
            <xsl:when test="string-length(/n1:ClinicalDocument/n1:title) &gt; 0">
            	<fo:block keep-together.within-page="always">
            		<xsl:value-of select="concat(/n1:ClinicalDocument/n1:code/@displayName, ' - ', /n1:ClinicalDocument/n1:title)"/>
            	</fo:block>
            </xsl:when>
            
           	<xsl:otherwise>
            	<fo:block>
               	 	<xsl:value-of select="/n1:ClinicalDocument/n1:code/@displayName"/>
               	 </fo:block>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    
    <xsl:template match="n1:ClinicalDocument">
		
		<!--  Dokumentinhalt : Bereich = Betreff  -->
			
		<xsl:variable name="varErstellDatum">
			<xsl:apply-templates select="n1:effectiveTime"/>
		</xsl:variable>
			
		<xsl:variable name="varErstellOrt">
			<xsl:value-of select="n1:author/n1:assignedAuthor/n1:representedOrganization/n1:addr/n1:city"/>
		</xsl:variable>
		
		<fo:block text-align="right" margin-top="1cm">
			<xsl:value-of select="concat($varErstellOrt,' den, ',$varErstellDatum)"/>
		</fo:block>
		
		<xsl:if test="string-length($glbVarEarztbriefTitel)>0">
			<fo:block font-size="12pt" font-weight="bold" text-decoration="underline">
				Betrf.: 
			</fo:block>
		
			<fo:block margin-top="0.3cm">	
				<xsl:value-of select="$glbVarEarztbriefTitel"/>
			</fo:block>
   		</xsl:if>
   		<!-- Dokumentinhalt: Bereich = Inhalt / Kategorien -->
   		
		<fo:block margin-top="1cm">
		
			<xsl:apply-templates select="n1:component/n1:structuredBody"/>
				
		</fo:block>
		
	</xsl:template>
	
	<!--                   ClinicalDocument.Component.StructuredBody     			   -->
    
    <xsl:template match="n1:component/n1:structuredBody">
    	
    	<!-- 	StructuredBody : Auflistung der Anamnesen -->
   		
   		<fo:block font-size="12pt" font-weight="bold" space-before="22pt">
   			Anamnese
   		</fo:block>
   		
   		
   		<xsl:call-template name="horizontaleLinie"/>
   			
   		<!-- StructuredBody : Anamnese.bisherige Anamnese  -->
    	
    	<fo:block keep-with-next.within-page="always">
    	
    		<fo:block font-weight="bold" space-before="12pt" space-after="4pt">
				bisherige Anamnese
   			</fo:block>
   			
    		<xsl:if test="n1:component/n1:section[n1:code/@code='10164-2']">
   			
   				<xsl:for-each select="n1:component/n1:section[n1:code/@code='10164-2']">
   				
   					<xsl:variable name="varDatum">
   						<xsl:value-of select="substring(n1:title,1,8)"/>
   					</xsl:variable>
   		
   					<xsl:variable name="varUeberschrift">
   						<xsl:value-of select="./n1:text/n1:table/n1:thead/n1:tr/n1:th"/>
   					</xsl:variable>
   					
   					<fo:block keep-together.within-page="always">
   					
   						<xsl:call-template name="templateSection">
   						
   							<xsl:with-param name="parDatum" 			select="$varDatum"/>
   							<xsl:with-param name="parUeberschrift"		select="$varUeberschrift"/>
   						
   						</xsl:call-template>
   					
   						<fo:block space-before="0.2cm" space-after="0.5cm">
   							<fo:table table-layout="fixed" width="100%">
   					
   								<xsl:for-each select="n1:text/n1:table/n1:tbody/n1:tr">
   					
   									<fo:table-body>
   										<fo:table-row>
   											<fo:table-cell margin-left="2cm" keep-together.within-column="always">
   												<fo:block padding-top="0.2cm">
   													<xsl:value-of select="n1:td"/>
   												</fo:block>
   											</fo:table-cell>
   										</fo:table-row>
   									</fo:table-body>
   							
   								</xsl:for-each>
   
   							</fo:table>
   						</fo:block>
   						
   					</fo:block>
   					
   				</xsl:for-each>
   				
   			</xsl:if>
   			
   		</fo:block>
   		
   		
   		<!-- StructuredBody : Anamnese.soziale Anamnese  -->
   		
   		<fo:block keep-with-next.within-page="always">
   		
   			<fo:block font-weight="bold" space-before="12pt" space-after="4pt">
				soziale Anamnese
   			</fo:block>
   			
   			<xsl:if test="n1:component/n1:section[n1:code/@code='29762-2']">
   			
   				<xsl:for-each select="n1:component/n1:section[n1:code/@code='29762-2']">
   		
   					<xsl:variable name="varDatum">
   						<xsl:value-of select="substring(n1:title,1,8)"/>
   					</xsl:variable>
   		
   					<xsl:variable name="varUeberschrift">
   						<xsl:value-of select="./n1:text/n1:table/n1:thead/n1:tr/n1:th"/>
   					</xsl:variable>
   					
   					<fo:block keep-together.within-page="always">
   					
   						<xsl:call-template name="templateSection">
   						
   							<xsl:with-param name="parDatum" 			select="$varDatum"/>
   							<xsl:with-param name="parUeberschrift"		select="$varUeberschrift"/>
   						
   						</xsl:call-template>
   					
   						<fo:block space-before="0.2cm" space-after="0.5cm">
   							<fo:table table-layout="fixed" width="100%">
   					
   								<xsl:for-each select="n1:text/n1:table/n1:tbody/n1:tr">
   					
   									<fo:table-body>
   										<fo:table-row>
   											<fo:table-cell margin-left="2cm" keep-together.within-column="always">
   												<fo:block padding-top="0.2cm">
   													<xsl:value-of select="td"/>
   												</fo:block>
   											</fo:table-cell>
   										</fo:table-row>
   									</fo:table-body>
   							
   								</xsl:for-each>
   
   							</fo:table>
   						</fo:block>
   						
   					</fo:block>
   					
   				</xsl:for-each>
   				
   			</xsl:if>
   			
   		</fo:block>
   		
   		
   		<!-- StructuredBody : Anamnese.aktuelle Anamnese  -->
   		
   		<fo:block keep-with-next.within-page="always">
   		
   			<fo:block font-weight="bold" space-before="12pt" space-after="4pt">
				aktuelle Anamnese
   			</fo:block> 
   			
   			<xsl:if test="n1:component/n1:section[n1:code/@code='11348-0']">
   		
   				<xsl:for-each select="n1:component/n1:section[n1:code/@code='11348-0']">
   				
   					<xsl:variable name="varDatum">
   						<xsl:value-of select="substring(n1:title,1,8)"/>
   					</xsl:variable>
   		
   					<xsl:variable name="varUeberschrift">
   						<xsl:value-of select="./n1:text/n1:table/n1:thead/n1:tr/n1:th"/>
   					</xsl:variable>
   					
   					<fo:block keep-together.within-page="always">
   					
   						<xsl:call-template name="templateSection">
   						
   							<xsl:with-param name="parDatum" 			select="$varDatum"/>
   							<xsl:with-param name="parUeberschrift"		select="$varUeberschrift"/>
   						
   						</xsl:call-template>
   					
   						<fo:block space-before="0.2cm" space-after="0.5cm">
   							<fo:table table-layout="fixed" width="100%">
   					
   								<xsl:for-each select="n1:text/n1:table/n1:tbody/n1:tr">
   					
   									<fo:table-body>
   										<fo:table-row>
   											<fo:table-cell margin-left="2cm" keep-together.within-column="always">
   												<fo:block padding-top="0.2cm">
   													<xsl:value-of select="n1:td"/>
   												</fo:block>
   											</fo:table-cell>
   										</fo:table-row>
   									</fo:table-body>
   							
   								</xsl:for-each>
   
   							</fo:table>
   						</fo:block>
   						
   					</fo:block>
   					
   				</xsl:for-each>
   				
   			</xsl:if>
   			
   		</fo:block>
   		
   		
   		<!-- 		StructuredBody : Auflistung der Befunde  -->	
   		
   		<fo:block font-size="12pt" font-weight="bold" space-before="22pt">
   			Befunde
   		</fo:block>
   		
   		<xsl:call-template name="horizontaleLinie"/>
   		
   		<fo:block keep-with-next.within-page="always"> 
   			
   			<xsl:if test="n1:component/n1:section[n1:code/@code='10210-3']">
   		
   				<xsl:for-each select="n1:component/n1:section[n1:code/@code='10210-3']">
   				
   					<xsl:variable name="varDatum">
   						<xsl:value-of select="substring(n1:title,1,8)"/>
   					</xsl:variable>
   		
   					<xsl:variable name="varUeberschrift">
   						<xsl:value-of select="./n1:text/n1:table/n1:thead/n1:tr/n1:th"/>
   					</xsl:variable>
   					
   					<fo:block keep-together.within-page="always">
   					
   						<xsl:call-template name="templateSection">
   						
   							<xsl:with-param name="parDatum" 			select="$varDatum"/>
   							<xsl:with-param name="parUeberschrift"		select="$varUeberschrift"/>
   						
   						</xsl:call-template>
   					
   						<fo:block space-before="0.2cm" space-after="0.5cm">
   							<fo:table table-layout="fixed" width="100%">
   					
   								<xsl:for-each select="n1:text/n1:table/n1:tbody/n1:tr">
   					
   									<fo:table-body>
   										<fo:table-row>
   											<fo:table-cell margin-left="2cm" keep-together.within-column="always">
   												<fo:block padding-top="0.2cm">
   													<xsl:value-of select="n1:td"/>
   												</fo:block>
   											</fo:table-cell>
   										</fo:table-row>
   									</fo:table-body>
   							
   								</xsl:for-each>
   
   							</fo:table>
   						</fo:block>
   						
   					</fo:block>
   					
   				</xsl:for-each>
   				
   			</xsl:if>
   			
   		</fo:block>
   		
   		
   		<!--  		StructuredBody : Auflistung der Laborwerte	-->	
   		
   		<xsl:call-template name="templateLaborwerte"/>
   		
   		
   		<!-- 		StructuredBody : Auflistung des Behandlungsplans -->
   		
   		<fo:block font-size="12pt" font-weight="bold" space-before="22pt">
   			Behandlungsplan
   		</fo:block>
   		
   		<xsl:call-template name="horizontaleLinie"/>
   		
   		<fo:block keep-with-next.within-page="always"> 
   			
   			<xsl:if test="n1:component/n1:section[n1:code/@code='18776-5']">
   		
   				<xsl:for-each select="n1:component/n1:section[n1:code/@code='18776-5']">
   				
   					<xsl:variable name="varDatum">
   						<xsl:value-of select="substring(n1:title,1,8)"/>
   					</xsl:variable>
   		
   					<xsl:variable name="varUeberschrift">
   						<xsl:value-of select="./n1:text/n1:table/n1:thead/n1:tr/n1:th"/>
   					</xsl:variable>
   					
   					<fo:block keep-together.within-page="always">
   					
   						<xsl:call-template name="templateSection">
   						
   							<xsl:with-param name="parDatum" 			select="$varDatum"/>
   							<xsl:with-param name="parUeberschrift"		select="$varUeberschrift"/>
   						
   						</xsl:call-template>
   					
   						<fo:block space-before="0.2cm" space-after="0.5cm">
   							<fo:table table-layout="fixed" width="100%">
   					
   								<xsl:for-each select="n1:text/n1:table/n1:tbody/n1:tr">
   					
   									<fo:table-body>
   										<fo:table-row>
   											<fo:table-cell margin-left="2cm" keep-together.within-column="always">
   												<fo:block padding-top="0.2cm">
   													<xsl:value-of select="n1:td"/>
   												</fo:block>
   											</fo:table-cell>
   										</fo:table-row>
   									</fo:table-body>
   							
   								</xsl:for-each>
   
   							</fo:table>
   						</fo:block>
   						
   					</fo:block>
   					
   				</xsl:for-each>
   				
   			</xsl:if>
   			
   		</fo:block>
    	
    	<!-- Auflistung der Risikofaktoren -->

  		<fo:block font-size="12pt" font-weight="bold" space-before="22pt">
   			Pricktest
   		</fo:block>
   		
   		<xsl:call-template name="horizontaleLinie"/>
   		
   		<fo:block keep-with-next.within-page="always"> 
   			
   			<xsl:if test="n1:component/n1:section[n1:code/@code='46467-7']">
   		
   				<xsl:for-each select="n1:component/n1:section[n1:code/@code='46467-7']">
   				
   					<xsl:variable name="varDatum">
   						<xsl:value-of select="substring(n1:title,1,8)"/>
   					</xsl:variable>
   		
   					<xsl:variable name="varUeberschrift">
   						<xsl:value-of select="./n1:text/n1:table/n1:thead/n1:tr/n1:th"/>
   					</xsl:variable>
   					
   					<fo:block keep-together.within-page="always">
   					
   						<xsl:call-template name="templateSection">
   						
   							<xsl:with-param name="parDatum" 			select="$varDatum"/>
   							<xsl:with-param name="parUeberschrift"		select="$varUeberschrift"/>
   						
   						</xsl:call-template>
   					
   						<fo:block space-before="0.2cm" space-after="0.5cm">
   							<fo:table table-layout="fixed" width="100%">
   					
   								<xsl:for-each select="n1:text/n1:table/n1:tbody/n1:tr">
   					
   									<fo:table-body>
   										<fo:table-row>
   											<fo:table-cell margin-left="2cm" keep-together.within-column="always">
   												<fo:block padding-top="0.2cm">
   													<xsl:value-of select="n1:td"/>
   												</fo:block>
   											</fo:table-cell>
   										</fo:table-row>
   									</fo:table-body>
   							
   								</xsl:for-each>
   
   							</fo:table>
   						</fo:block>
   						
   					</fo:block>
   					
   				</xsl:for-each>
   				
   			</xsl:if>
   			
   		</fo:block>
   		
   		<!-- Auflistung der Histologie -->
   		
   		<fo:block font-size="12pt" font-weight="bold" space-before="22pt">
   			Histologie
   		</fo:block>
   		
   		<xsl:call-template name="horizontaleLinie"/>
   		
   		<fo:block keep-with-next.within-page="always"> 
   			
   			<xsl:if test="n1:component/n1:section[n1:code/@code='22036-8']">
   		
   				<xsl:for-each select="n1:component/n1:section[n1:code/@code='22036-8']">
   				
   					<xsl:variable name="varDatum">
   						<xsl:value-of select="substring(n1:title,1,8)"/>
   					</xsl:variable>
   		
   					<xsl:variable name="varUeberschrift">
   						<xsl:value-of select="./n1:text/n1:table/n1:thead/n1:tr/n1:th"/>
   					</xsl:variable>
   					
   					<fo:block keep-together.within-page="always">
   					
   						<xsl:call-template name="templateSection">
   						
   							<xsl:with-param name="parDatum" 			select="$varDatum"/>
   							<xsl:with-param name="parUeberschrift"		select="$varUeberschrift"/>
   						
   						</xsl:call-template>
   					
   						<fo:block space-before="0.2cm" space-after="0.5cm">
   							<fo:table table-layout="fixed" width="100%">
   					
   								<xsl:for-each select="n1:text/n1:table/n1:tbody/n1:tr">
   					
   									<fo:table-body>
   										<fo:table-row>
   											<fo:table-cell margin-left="2cm" keep-together.within-column="always">
   												<fo:block padding-top="0.2cm">
   													<xsl:value-of select="n1:td"/>
   												</fo:block>
   											</fo:table-cell>
   										</fo:table-row>
   									</fo:table-body>
   							
   								</xsl:for-each>
   
   							</fo:table>
   						</fo:block>
   						
   					</fo:block>
   					
   				</xsl:for-each>
   				
   			</xsl:if>
   			
   		</fo:block>
   		
   		<!-- Auflistung der Medikation -->
   		
   		<fo:block font-size="12pt" font-weight="bold" space-before="22pt">
   			Medikation
   		</fo:block>
   		
   		<xsl:call-template name="horizontaleLinie"/>
   		
   		<fo:block keep-with-next.within-page="always"> 
   			
   			<xsl:if test="n1:component/n1:section[n1:code/@code='19009-0']">
   		
   				<xsl:for-each select="n1:component/n1:section[n1:code/@code='19009-0']">
   				
   					<xsl:variable name="varDatum">
   						<xsl:value-of select="substring(title,1,8)"/>
   					</xsl:variable>
   		
   					<xsl:variable name="varUeberschrift">
   						<xsl:value-of select="./n1:text/n1:table/n1:thead/n1:tr/n1:th"/>
   					</xsl:variable>
   					
   					<fo:block keep-together.within-page="always">
   					
   						<xsl:call-template name="templateSection">
   						
   							<xsl:with-param name="parDatum" 			select="$varDatum"/>
   							
   						</xsl:call-template>
   					
   						<fo:block space-before="0.2cm" space-after="0.5cm">
   							<fo:table table-layout="fixed" width="100%">
   					
   								<xsl:for-each select="n1:text/n1:table/n1:tbody/n1:tr">
   					
   									<fo:table-body>
   										<fo:table-row>
   											<fo:table-cell margin-left="2cm" keep-together.within-column="always">
   												<fo:block padding-top="0.2cm">
   													<xsl:value-of select="n1:td"/>
   												</fo:block>
   											</fo:table-cell>
   										</fo:table-row>
   									</fo:table-body>
   							
   								</xsl:for-each>
   
   							</fo:table>
   						</fo:block>
   						
   					</fo:block>
   					
   				</xsl:for-each>
   				
   			</xsl:if>
   			
   		</fo:block>
    	
    	
    	<!-- Auflistung der Diagnosen -->
	
		<xsl:call-template name="templateDiagnosen"/>
		
		
		<!-- Auflistung der Prozeduren -->
   		
   		<fo:block keep-together.within-page="always">
   		
   			<fo:block font-size="12pt" font-weight="bold" space-before="22pt">
   				Prozeduren
   			</fo:block>
   		
   			<xsl:call-template name="horizontaleLinie"/>
   		
   			<fo:block keep-with-next.within-page="always"> 
   			
   				<xsl:if test="n1:component/n1:section[n1:code/@code='29554-3']">
   		
   					<xsl:for-each select="n1:component/n1:section[n1:code/@code='29554-3']">
   				
   						<xsl:variable name="varDatum">
   							<xsl:value-of select="substring(n1:title,1,8)"/>
   						</xsl:variable>
   		
   						<xsl:variable name="varUeberschrift">
   							<xsl:value-of select="./n1:text/n1:table/n1:thead/n1:tr/n1:th"/>
   						</xsl:variable>
   					
   						<fo:block keep-together.within-page="always">
   					
   							<xsl:call-template name="templateSection">
   						
   								<xsl:with-param name="parDatum"  select="$varDatum"/>
   							
   							</xsl:call-template>
   					
   							<fo:block space-before="0.2cm" space-after="0.5cm">
   								<fo:table table-layout="fixed" width="100%">
   					
   									<xsl:for-each select="n1:text/n1:table/n1:tbody/n1:tr">
   					
   										<fo:table-body>
   											<fo:table-row>
   												<fo:table-cell margin-left="2cm" keep-together.within-column="always">
   													<fo:block padding-top="0.2cm">
   														<xsl:value-of select="n1:td"/>
   													</fo:block>
   												</fo:table-cell>
   											</fo:table-row>
   										</fo:table-body>
   							
   									</xsl:for-each>
   
   								</fo:table>
   							</fo:block>
   						
   						</fo:block>
   					
   					</xsl:for-each>
   				
   				</xsl:if>
   			
   			</fo:block>
   		
   		</fo:block>
   			
   		<!-- Auflistung der Epikrise -->
   		
   		<fo:block keep-together.within-page="always">
   		
   			<fo:block font-size="12pt" font-weight="bold" space-before="22pt">
   				Epikrise
   			</fo:block>
   		
   			<xsl:call-template name="horizontaleLinie"/>
   		
   			<fo:block keep-with-next.within-page="always"> 
   			
   				<xsl:if test="n1:component/n1:section[n1:code/@code='46070-9']">
   		
   					<xsl:for-each select="n1:component/n1:section[n1:code/@code='46070-9']">
   				
   						<xsl:variable name="varDatum">
   							<xsl:value-of select="substring(n1:title,1,8)"/>
   						</xsl:variable>
   		
   						<xsl:variable name="varUeberschrift">
   							<xsl:value-of select="./n1:text/n1:table/n1:thead/n1:tr/n1:th"/>
   						</xsl:variable>
   					
   						<fo:block keep-together.within-page="always">
   					
   							<xsl:call-template name="templateSection">
   						
   								<xsl:with-param name="parDatum" 			select="$varDatum"/>
   							
   							</xsl:call-template>
   					
   							<fo:block space-before="0.2cm" space-after="0.5cm">
   								<fo:table table-layout="fixed" width="100%">
   					
   									<xsl:for-each select="n1:text/n1:table/n1:tbody/n1:tr">
   					
   										<fo:table-body>
   											<fo:table-row>
   												<fo:table-cell margin-left="2cm" keep-together.within-column="always">
   													<fo:block padding-top="0.2cm">
   														<xsl:value-of select="n1:td"/>
   													</fo:block>
   												</fo:table-cell>
   											</fo:table-row>
   										</fo:table-body>
   							
   									</xsl:for-each>
   
   								</fo:table>
   							</fo:block>
   						
   						</fo:block>
   					
   					</xsl:for-each>
   				
   				</xsl:if>
   			
   			</fo:block>
   		
   		</fo:block>
   			
	</xsl:template>
	
	
	
	<!-- ============ allgemeine Vorlage zur Anzeige einer SECTION =================   -->
	
	<xsl:template name="templateSection">
		
		<xsl:param name="parDatum"/>
		<xsl:param name="parUeberschrift"/>
		<xsl:param name="parInhalt"/>
   		<xsl:param name="parBodyPath"/>
   		
		<fo:table table-layout="fixed" width="100%">
		
   			<fo:table-header>
   			
   				<fo:table-row>
   				
   					<fo:table-cell width="2cm" max-width="2cm" text-align="left">
						<fo:block></fo:block>
					</fo:table-cell>
							
					<fo:table-cell max-width="10cm" text-align="left">
						<fo:block></fo:block>
					</fo:table-cell>
					
   				</fo:table-row>
   				
   			</fo:table-header>
   			
   			<fo:table-body>
   			
   				<fo:table-row empty-cells="show">
   									
					<fo:table-cell text-align="left" font-weight="bold">
					
   						<fo:block>
   							<xsl:value-of select="$parDatum"/>
   						</fo:block>
   						
   					</fo:table-cell>
   										
   					<fo:table-cell text-align="left"
   									keep-together.within-column="always">
   						<fo:block>
   							<xsl:value-of select="$parUeberschrift"/>
						</fo:block>
						
					</fo:table-cell>
					
   				</fo:table-row>
   				
   			</fo:table-body>
   			
   		</fo:table>
   		
	</xsl:template>
	
	
	<!-- ==================== 		Laborwertetabelle 		========================   -->
	
	<xsl:template name="templateLaborwerte">
	
		<fo:block font-size="12pt" font-weight="bold" space-before="22pt">
   			Laborwerte
   		</fo:block>
   		
   		<xsl:call-template name="horizontaleLinie"/>
   		
   		<xsl:if test="/n1:ClinicalDocument/n1:component/n1:structuredBody/n1:component/n1:section[n1:code/@code='18723-7']">
   			
   			<fo:table table-layout="fixed" 
   						width="100%" 
   						border="0.5pt solid black">
   				
   				<fo:table-column column-number="1" column-width="10%" border="0.5pt solid black"/>
   				<fo:table-column column-number="2" column-width="15%" border="0.5pt solid black"/>
   				<fo:table-column column-number="3" column-width="35%" border="0.5pt solid black"/>
   				<fo:table-column column-number="4" column-width="10%" border="0.5pt solid black"/>
   				<fo:table-column column-number="5" column-width="15%" border="0.5pt solid black"/>
   				<fo:table-column column-number="6" column-width="15%" border="0.5pt solid black"/>
   					
   				<fo:table-header background-color="#E6E6E6">
   				
   					<fo:table-row>
   			
   						<fo:table-cell column-number="1">
   							
   							<fo:block text-align="center" border="0.5pt solid black">
   								Datum
   							</fo:block>
   								
   						</fo:table-cell>
   						<fo:table-cell column-number="2">
   							
   							<fo:block text-align="center" border="0.5pt solid black">
   								Test
   							</fo:block>
   							
   						</fo:table-cell>
   						<fo:table-cell column-number="3">
   						
   							<fo:block text-align="center" border="0.5pt solid black">
   								Beschreibung
   							</fo:block>
   							
   						</fo:table-cell>
   						<fo:table-cell column-number="4">
   						
   							<fo:block text-align="center" border="0.5pt solid black">
   								Wert
   							</fo:block>
   							
   						</fo:table-cell>
   						<fo:table-cell column-number="5">
   							
   							<fo:block text-align="center" border="0.5pt solid black">
   								Einheit
   							</fo:block>
   								
   						</fo:table-cell>
   						<fo:table-cell column-number="6">
   							
   							<fo:block text-align="center" border="0.5pt solid black">
   								Normbereich
   							</fo:block>
   								
   						</fo:table-cell>
   							
   					</fo:table-row>
   						
   				</fo:table-header>
   					
   				<fo:table-body>
   					
   					<xsl:for-each select="/n1:ClinicalDocument/n1:component/n1:structuredBody/n1:component/n1:section[n1:code/@code='18723-7']">
   						
   						<xsl:variable name="varDatum" select="substring(n1:title, 1, 8)"/>
   						
   						<xsl:for-each select="n1:text/n1:table/n1:tbody/n1:tr">
   						
   							<fo:table-row>
   							
   								<fo:table-cell border="0.5pt solid black" padding="2pt" margin-left="0" keep-together.within-column="always">
   									<fo:block>
   										<xsl:value-of select="$varDatum"/>
   									</fo:block>
   								</fo:table-cell>
   								
   								<fo:table-cell border="0.5pt solid black" padding="2pt" margin-left="0" keep-together.within-column="always">
   									<fo:block>
   										<xsl:value-of select="n1:td[1]"/>
   									</fo:block>
   								</fo:table-cell>
   								
   								<fo:table-cell border="0.5pt solid black" padding="2pt" margin-left="0" keep-together.within-column="always">
   									<fo:block>
   										<xsl:value-of select="n1:td[2]"/>
   									</fo:block>
   								</fo:table-cell>
   								
   								<fo:table-cell border="0.5pt solid black" padding="2pt" margin-left="0" keep-together.within-column="always">
   									<fo:block>
   										<xsl:value-of select="n1:td[3]"/>
   									</fo:block>
   								</fo:table-cell>
   								
   								<fo:table-cell border="0.5pt solid black" padding="2pt" margin-left="0" keep-together.within-column="always">
   									<fo:block>
   										<xsl:value-of select="n1:td[4]"/>
   									</fo:block>
   								</fo:table-cell>
   								
   								<fo:table-cell border="0.5pt solid black" padding="2pt" margin-left="0" keep-together.within-column="always">
   									<fo:block>
   										<xsl:value-of select="n1:td[5]"/>
   									</fo:block>
   								</fo:table-cell>
   								
   							</fo:table-row>
   							
   						</xsl:for-each>
   						
   					</xsl:for-each>
   						
   				</fo:table-body>
   				
   			</fo:table>
   					
		</xsl:if>
		
	</xsl:template>
	
	
	<!-- ==================== 		Diagnosetabelle 		========================   -->
	
	<xsl:template name="templateDiagnosen">
	
		<fo:block font-size="12pt" font-weight="bold" space-before="22pt">
   			Diagnosen mit ICD 10
   		</fo:block>
   		
   		<xsl:call-template name="horizontaleLinie"/>
   		
   		<xsl:if test="/n1:ClinicalDocument/n1:component/n1:structuredBody/n1:component/n1:section[n1:code/@code='29308-4']">
   			
   			<fo:table table-layout="fixed" 
   						width="100%" 
   						border="0.5pt solid black">
   				
   				<fo:table-column column-number="1" column-width="10%" border="0.5pt solid black"/>
   				<fo:table-column column-number="2" column-width="10%" border="0.5pt solid black"/>
   				<fo:table-column column-number="3" column-width="50%" border="0.5pt solid black"/>
   				<fo:table-column column-number="4" column-width="15%" border="0.5pt solid black"/>
   				<fo:table-column column-number="5" column-width="15%" border="0.5pt solid black"/>
   					
   				<fo:table-header background-color="#E6E6E6">
   				
   					<fo:table-row>
   			
   						<fo:table-cell column-number="1">
   							
   							<fo:block text-align="center" border="0.5pt solid black">
   								Datum
   							</fo:block>
   								
   						</fo:table-cell>
   						<fo:table-cell column-number="2">
   							
   							<fo:block text-align="center" border="0.5pt solid black">
   								ICD Code
   							</fo:block>
   							
   						</fo:table-cell>
   						<fo:table-cell column-number="3">
   						
   							<fo:block text-align="center" border="0.5pt solid black">
   								Diagnose
   							</fo:block>
   							
   						</fo:table-cell>
   						<fo:table-cell column-number="4">
   						
   							<fo:block text-align="center" border="0.5pt solid black">
   								Lokalisation
   							</fo:block>
   							
   						</fo:table-cell>
   						<fo:table-cell column-number="5">
   							
   							<fo:block text-align="center" border="0.5pt solid black">
   								Zusatz
   							</fo:block>
   								
   						</fo:table-cell>
   							
   					</fo:table-row>
   						
   				</fo:table-header>
   					
   				<fo:table-body>
   					
   					<xsl:for-each select="/n1:ClinicalDocument/n1:component/n1:structuredBody/n1:component/n1:section[n1:code/@code='29308-4']">
   						
   						<xsl:variable name="varDatum" select="substring(n1:title, 1, 8)"/>
   						
   						<xsl:for-each select="n1:text/n1:table/n1:tbody/n1:tr">
   						
   							<fo:table-row>
   							
   								<fo:table-cell border="0.5pt solid black" padding="2pt" margin-left="0" keep-together.within-column="always">
   									<fo:block>
   										<xsl:value-of select="$varDatum"/>
   									</fo:block>
   								</fo:table-cell>
   								
   								<fo:table-cell border="0.5pt solid black" padding="2pt" margin-left="0" keep-together.within-column="always">
   									<fo:block>
   										<xsl:value-of select="n1:td[1]"/>
   									</fo:block>
   								</fo:table-cell>
   								
   								<fo:table-cell border="0.5pt solid black" padding="2pt" margin-left="0" keep-together.within-column="always">
   									<fo:block>
   										<xsl:value-of select="n1:td[2]"/>
   									</fo:block>
   								</fo:table-cell>
   								
   								<fo:table-cell border="0.5pt solid black" padding="2pt" margin-left="0" keep-together.within-column="always">
   									<fo:block>
   										<xsl:value-of select="n1:td[3]"/>
   									</fo:block>
   								</fo:table-cell>
   								
   								<fo:table-cell border="0.5pt solid black" padding="2pt" margin-left="0" keep-together.within-column="always">
   									<fo:block>
   										<xsl:value-of select="n1:td[4]"/>
   									</fo:block>
   								</fo:table-cell>
   								
   							</fo:table-row>
   							
   						</xsl:for-each>
   						
   					</xsl:for-each>
   						
   				</fo:table-body>
   				
   			</fo:table>
   					
		</xsl:if>
		
	</xsl:template>
	
	
    <!-- ===================   RelatedDocumentAuhtorization   ======================   -->
    
    <!-- Template: ClinicalDocument.relatedDocument.parentDocument.Auhtorization 
    
    <xsl:template match="authorization">
    	<xsl:value-of select="id"/>
    	<xsl:value-of select="code"/>
    	<xsl:value-of select="statusCode"/>
    </xsl:template>
    -->
    
    <!-- Template: ClinicalDocument.relatedDocument.parentDocument 
    
    <xsl:template match="parentDocument">
    	<xsl:apply-templates select="authorization"/>
    </xsl:template>
    -->
    
    
    <!-- Template: ClinicalDocument.relatedDocument 
    
    <xsl:template match="relatedDocument">
    	<xsl:apply-templates select="parentDocument"/>
    </xsl:template>
    -->
    
    
    <!-- =================== 		LegalAuthenticator		========================   -->
    
    <!-- Template: ClinicalDocument.legalAuthenticator.assigneEntity.representedOrganization 
    
    <xsl:template match="representedOrganization">
    	<xsl:value-of select="name"/>
    	<xsl:apply-templates select="addr"/>
    	<xsl:apply-templates select="telecom"/>
    </xsl:template>
    -->
    
    <!-- Template: ClinicalDocument.legalAuthenticator.assigneEntity.assignedPerson 
    
    <xsl:template match="assignedPerson">
    	<xsl:value-of select="prefix"/>
    	<xsl:apply-templates select="name"/>
    </xsl:template>
    -->
    
    <!-- Template: ClinicalDocument.legalAuthenticator.assigneEntity 
    
    <xsl:template match="asssignedEntity"/>
    	<xsl:apply-templates select="assignedPerson"/>
    </xsl:template>
    -->
    
    <!-- Template: ClinicalDocument.legalAuthenticator 
    
    <xsl:template match="legalAuthenticator">
    	<xsl:apply-templates select="assignedEntity"/>
    </xsl_template>
    -->
    
    
    <!-- Template: ClinicalDocument.legalAuthenticator 
    
    <xsl:template match="legalAuthenticator">
    </xsl:template>
    -->
    
    <!-- ===================	RelatedDocumentAuthorization  ======================   -->
    
    <!-- Template: ClinicalDocument.relatedDocumentAuthorization 
    
    <xsl:template match="relatedAuthenticator">
    </xsl:template>
    -->
    
    
    <!-- Template: component 
    
    <xsl:template match="component">
    </xsl:template>
    -->
    
    
    <!-- Template: section 
    
    <xsl:template match="section">
    </xsl:template>
    -->

	
</xsl:stylesheet>
