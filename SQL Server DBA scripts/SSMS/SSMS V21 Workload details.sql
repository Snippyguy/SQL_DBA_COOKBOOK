/***************************************************************************************************************************************
Code Description	 : SSMS V21 Workload details																				       *
Author Name		 	 : Sayan Dey					  																				   *
Company Name		 : Snippyguy																									   *
Website		     	 : www.snippyguy.com																							   *
LinkedIn			 : https://www.linkedin.com/in/snippyguy/																		   *																						
GitHub				 : https://github.com/Snippyguy																					   *
Tableau Public		 : https://public.tableau.com/app/profile/snippyguy/vizzes														   * 
License			 	 : MIT, CC0																										   *
Creation Date		 : 24/11/2023																									   *
Last Modified By 	 : 24/11/2023																									   *
Last Modification	 : Initial Creation  																							   *
Modification History : 	 																											   *
***************************************************************************************************************************************/

/***************************************************************************************************************************************
*                                                Copyright (C) 2025 Sayan Dey														   *
*                                                All rights reserved. 																   *
* 																																	   *
* Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files     *
* (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge,  *
* publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do   *
* so, subject to the following conditions:																							   *
*																																	   *
*																																	   *
* You may alter this code for your own * Commercial* & *non-commercial* purposes. 													   *
* You may republish altered code as long as you include this copyright and give due credit. 										   *
* 																																	   *
* 																																	   *
* The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.	   *
*																																	   *
*																																	   *
* THE SOFTWARE (CODE AND INFORMATION) IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED *
* TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR 		   *
* COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING  *
* FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.										   *
*																																	   *
* 																																	   *
***************************************************************************************************************************************/

/*

1. Core Editor: The Core Editor in SSMS 21 is the essential workload that provides the fundamental features needed to run SSMS, including the Query Editor for writing and executing T-SQL, the Object Explorer to navigate and manage databases, 
                and core database management functions such as backups, security, and high availability configurations. It also installs required connectivity drivers (ODBC and OLE DB for SQL Server) and the Microsoft Visual C++ Redistributable runtime. 
                In short, the Core Editor is the base package of SSMS—everything else (AI, BI, Code Tools, Migration) is optional and built on top of it.
				Core Editor = SSMS essentials → Query Editor + Object Explorer + Database Management Features + Drivers (MSODBC & MSOLEDBSQL) + Runtime.			
    
	Workload ID: Microsoft.VisualStudio.Component.CoreEditor

2. AI Assistance (optional): The AI Assistance workload in SSMS 21 adds Copilot for SQL Server, which helps developers and DBAs write queries faster and smarter by offering AI-powered code suggestions, query completions, and natural language to SQL translation. 
							 It integrates directly into the Query Editor, so you can type a prompt (like “get top 10 customers by sales”) and Copilot will generate the corresponding T-SQL, along with contextual recommendations to optimize queries. 
							 In short, AI Assistance makes SSMS more intelligent by using machine learning to speed up query writing and improve productivity.
							 
							 Copilot in SSMS (Microsoft.SSMS.Component.Copilot)
							 
	Workload ID: Microsoft.SqlServer.Workload.SSMS.AI

3. Business Intelligence (BI) (Optional): The Business Intelligence (BI) workload in SSMS 21 provides tools to manage and develop the SQL Server BI stack, which goes beyond just databases. 
										  It includes Analysis Services (SSAS) for creating and managing OLAP cubes and tabular models used in data analytics, Integration Services (SSIS) for designing and deploying ETL (Extract, Transform, Load) workflows 
										  that move and transform data between systems, and Reporting Services (SSRS) for building, publishing, and managing paginated and interactive reports. 
										  In short, the BI workload equips SSMS with everything needed to handle enterprise-level analytics, data integration, and reporting.
										  BI = Analysis Services (SSAS) → OLAP / Tabular model management + Integration Services (SSIS) → ETL package development/deployment + Reporting Services (SSRS) → Report design & server management
										  
										  Microsoft.SSMS.Component.AS + Microsoft.SSMS.Component.IS + Microsoft.SSMS.Component.RS
										  
	Workload ID: Microsoft.SqlServer.Workload.SSMS.BI
	
4. Code Tool (Optional): The Code Tools workload in SSMS 21 adds developer productivity features on top of the Core Editor.
						 It mainly includes Git integration (via Team Explorer with MinGit) so you can connect SSMS projects to source control directly, and an optional Help Viewer that lets you download and use SQL Server documentation offline. 
						 In short, Code Tools is meant for developers who want built-in version control and offline learning resources while working in SSMS.
						 Developer productivity tools.
						 Help Viewer (offline docs) – optional (Microsoft.Component.HelpViewer)
						 Git integration – required (Microsoft.VisualStudio.Component.TeamExplorer.MinGit)

	Workload ID: Microsoft.SqlServer.Workload.SSMS.CodeTools

5. Hybrid and Migration (Optional): The Hybrid and Migration workload in SSMS 21 provides tools to help move or extend SQL Server workloads to the cloud and hybrid environments. Its key feature is the SQL Server Migration Assistant (SSMA), 
									which simplifies migrating databases from on-premises SQL Server or other platforms (like Oracle, MySQL, or PostgreSQL) to Azure SQL or newer SQL Server versions. 
									It also supports hybrid management by offering connectivity and guidance for integrating on-premises databases with Azure services. In short, this workload is focused on cloud readiness and database migration.
									
									Migration Assistant (Microsoft.SSMS.Component.MigrationAssistant)
									
	Workload ID: Microsoft.SqlServer.Workload.SSMS.HybridAndMigration
	

How to Use These IDs: You can customize your SSMS installation from the command line or through the Visual Studio Installer by specifying one or more workloads. For example:
						vs_SSMS.exe --add Microsoft.SqlServer.Workload.SSMS.AI --add Microsoft.SqlServer.Workload.SSMS.HybridAndMigration --includeRequired
This installs the AI Assistance and Hybrid & Migration workloads along with all required dependencies. If you'd like to include additional recommended or optional components (like the Help Viewer or migration tools), specify those as needed.

*/