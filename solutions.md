## Mein gewählter Anwendungsfall: Docker Multi-Container Webanwendung

## 1. Problemstellung und Motivation (Dokumentiere deine Wahl)

## Problem: Das manuelle Aufsetzen und Verwalten einer Anwendung, die aus mehreren miteinander verbundenen Docker-Containern besteht (z.B. ein Frontend, ein Backend und eine Datenbank), ist fehleranfällig, zeitaufwendig und schwer reproduzierbar. Konfigurationen für Netzwerke, Volumes und Port-Mappings müssen konsistent über alle Komponenten hinweg verwaltet werden. Bei Änderungen oder dem Aufsetzen einer neuen Umgebung (Entwicklung, Test, Staging) müssen alle Schritte exakt wiederholt werden.

## Warum Terraform/IaC?
Infrastructure as Code (IaC) mit Terraform bietet hier eine ideale Lösung, um:
Deklarative Definition: Die gesamte Infrastruktur (Docker-Netzwerk, Volumes, Container, deren Konfiguration und Verknüpfungen) wird in HCL-Code beschrieben.

Automatisierung: Das Aufsetzen und Abbauen der Umgebung erfolgt automatisiert und schnell.

Reproduzierbarkeit: Die gleiche Konfiguration kann zuverlässig auf verschiedenen Systemen oder zu 
verschiedenen Zeiten bereitgestellt werden, was Konsistenz gewährleistet.

Versionierung: Die Infrastrukturdefinition kann versioniert (z.B. mit Git) werden, Änderungen sind nachvollziehbar.

Modularität & Wiederverwendbarkeit: Gemeinsame Muster (z.B. ein einzelner Service-Container) können in Module gekapselt und wiederverwendet werden.

Parameterisierung: Durch Variablen kann die Konfiguration leicht an unterschiedliche Bedürfnisse (z.B. andere Image-Versionen, Port-Nummern) angepasst werden, ohne den Kerncode zu ändern.

## Sinnvoller Einsatz der geforderten Bausteine in diesem Anwendungsfall:

## Ressourcen (3+): Wir benötigen mindestens:
docker_network: Ein benutzerdefiniertes Netzwerk, damit die Container miteinander kommunizieren können.
docker_volume (optional, aber gut für Persistenz, z.B. für die Datenbank): Ein Volume für persistente Daten.
docker_container (Frontend): Ein Container für das Frontend (z.B. Nginx oder eine React-App).
docker_container (Backend): Ein Container für das Backend (z.B. eine Node.js/Express API).
docker_container (Datenbank): Ein Container für die Datenbank (z.B. PostgreSQL).

## Variablen (3+ unterschiedliche Typen):
string: Für Image-Namen (z.B. frontend_image_name, backend_image_tag), Container-Präfixe, Netzwerkname.
number: Für externe Port-Mappings (z.B. frontend_external_port), Anzahl der (simulierten) Backend-Replikate (wenn man das mit count umsetzen würde, für dieses Beispiel aber vielleicht zu viel).
map(string) oder list(object): Für Umgebungsvariablen der Container (z.B. Datenbank-URL für das Backend).
bool: z.B. enable_db_persistence um zu steuern, ob ein Volume für die DB erstellt wird.

## Outputs (2+):
URL/Endpunkt des Frontends (z.B. http://localhost:${var.frontend_external_port}).
Name des erstellten Docker-Netzwerks.
Interne IP-Adressen der Container im Docker-Netzwerk (nützlich für Debugging oder wenn andere lokale Dienste darauf zugreifen sollen).

## Locals (1+):
Generierung von konsistenten Namen für Container, Netzwerk, Volume basierend auf einem Projektpräfix (z.B. local.app_prefix = "my-web-app" und dann name = "${local.app_prefix}-frontend").
Zusammensetzung der Datenbank-Verbindungs-URL für das Backend.
Standardisierte Docker-Labels für alle Ressourcen.

## Modul (1):
Ein Modul app_service könnte einen einzelnen Anwendungscontainer (Frontend oder Backend) kapseln, der ein Image, Port-Mappings, Umgebungsvariablen und den Anschluss an ein bestimmtes Netzwerk als Input-Variablen nimmt. Dieses Modul könnte dann mehrfach für Frontend und Backend instanziiert werden.
Alternativ ein Modul für die "Datenbank-Einheit" (Container + Volume).
Dieser Anwendungsfall ist nicht-trivial, da er die Orchestrierung mehrerer voneinander abhängiger Docker-Ressourcen erfordert, deren Konfiguration durch Variablen flexibel gestaltet und deren wichtige Endpunkte über Outputs zugänglich gemacht werden. Die Nutzung eines Moduls fördert die Struktur und Wiederverwendbarkeit.


## Skizze der Infrastruktur

+---------------------------------------------------------------------+
| Docker Host (Dein lokaler Rechner)                                  |
|                                                                     |
|  +---------------------------------+     +------------------------+ |
|  | Docker Netzwerk                 |     | Docker Volume          | |
|  | (Name: z.B. var.network_name)   |     | (Name: z.B. local.db_volume_name)| |
|  | (local.network_name)            |     +------------------------+ |
|  +---------------------------------+               ^                |
|       ^       ^             ^                      | (mountet auf)  |
|       |       |             |                      |                |
|       |       |             |   (Verbindet sich mit)|                |
|  +----|-------|-------------|----------------------|--------------+ |
|  |    v       |             |                      v              | |
|  |  +---------+---------+  +---------+---------+  +-------------+ | |
|  |  | Frontend Container|  | Backend Container |  | DB Container| | |
|  |  | (z.B. Nginx)      |  | (z.B. Node.js API)|  | (PostgreSQL)| | |
|  |  | Image: var.fe_image|  | Image: var.be_image|  | Image: var.db_image| | |
|  |  | Port: HostPort -> 80|  | Port: HostPort ->3000|  | (Interner Port) | | |
|  |  | (var.fe_ext_port) |  | (var.be_ext_port) |  |             | | |
|  |  | Netzwerk: verbunden|  | Netzwerk: verbunden|  | Netzwerk: verbunden| | |
|  |  +-------------------+  +-------------------+  +-------------+ | |
|  +-----------------------------------------------------------------+ |
|                                                                     |
+---------------------------------------------------------------------+

Legende:
  <-- Exponierter Port zum Host
  --- Netzwerkverbindung innerhalb des Docker Netzwerks
  ^   Abhängigkeit oder Verbindung

Terraform Bausteine im Einsatz (Beispiele):
- Provider: "docker"
- Ressourcen:
    - docker_network.app_network
    - docker_container.frontend
    - docker_container.backend
    - docker_container.database
    - docker_volume.db_data (optional)
- Modul "app_service" (kapselt einen Container wie Frontend oder Backend):
    - Input: container_name, image_name, external_port, network_ids
    - Output: container_id, internal_ip
- Variablen:
    - project_prefix (string)
    - frontend_image (string)
    - backend_image (string)
    - db_image (string)
    - frontend_external_port (number)
    - backend_external_port (number)
    - db_env_vars (map(string))
- Locals:
    - frontend_container_name = "${var.project_prefix}-frontend"
    - backend_container_name  = "${var.project_prefix}-backend"
    - db_container_name       = "${var.project_prefix}-db"
    - network_name            = "${var.project_prefix}-net"
- Outputs:
    - frontend_url = "http://localhost:${var.frontend_external_port}"
    - backend_api_endpoint_internal = "http://${module.backend.internal_ip}:${module.backend.internal_port}" (wenn das Modul diese Infos liefert)



   ##  Erläuterung der Skizze:

Alle Container laufen innerhalb eines benutzerdefinierten Docker-Netzwerks, was ihnen erlaubt, sich gegenseitig über ihre Container-Namen zu erreichen.
Das Frontend (z.B. Nginx, der statische HTML/JS/CSS-Dateien ausliefert oder als Reverse Proxy für das Backend dient) exponiert einen Port zum Docker-Host, sodass es vom Browser aus erreichbar ist.
Das Backend (z.B. eine Node.js API) exponiert ebenfalls einen Port (entweder zum Host für direkte Tests oder nur intern im Docker-Netzwerk, wenn das Frontend als Proxy dient). Es verbindet sich mit der Datenbank.
Die Datenbank (z.B. PostgreSQL) speichert ihre Daten idealerweise in einem Docker-Volume, um Persistenz über Container-Neustarts hinweg zu gewährleisten. Sie ist typischerweise nur innerhalb des Docker-Netzwerks erreichbar.
Terraform verwaltet die Erstellung und Konfiguration all dieser Komponenten.

## Vergleich zu Vorkenntnissen:

Wie hättest du das manuell/mit Skripten/CloudFormation/ARM gemacht?

Ich hätte eine Cloudformation Script geschrieben und jede ressource einzeln definiert. 

Unterschiede? Vor-/Nachteile von Terraform für diesen spezifischen Fall?

Nachteil, die Infrastruktur ist manuell nicht 1:1 reproduzierbar und es daurt viel länger Infrastruktur bereitzustellen. Der Vorteil mit Werkzeugen wie Terraform liegt darin, dass sich Infrastruktur auf Knopfdruck 1:1 überall erstellen- und auch auf Knopfdruck wieder wegräumen läßt. Das spart Geld und Zeit und trägt somit zur Effizenz eine Projekts erheblich bei. 

![alt text](<Screenshot 2025-06-05 115308.png>)
![alt text](<Screenshot 2025-06-05 120637.png>)
![alt text](<Screenshot 2025-06-05 120803.png>)
![alt text](<Screenshot 2025-06-05 120814.png>)
![alt text](<Screenshot 2025-06-05 120826.png>)
![alt text](<Screenshot 2025-06-05 120839.png>)
![alt text](<Screenshot 2025-06-05 121007.png>)
![alt text](<Screenshot 2025-06-05 121015.png>)
![alt text](<Screenshot 2025-06-05 121027.png>)
![alt text](<Screenshot 2025-06-05 121038.png>)
![alt text](<Screenshot 2025-06-05 121059.png>)
![alt text](<Screenshot 2025-06-05 121159.png>)
![alt text](<Screenshot 2025-06-05 121733.png>)
![alt text](<Screenshot 2025-06-05 122304.png>)
![alt text](<Screenshot 2025-06-05 122313.png>)
![alt text](<Screenshot 2025-06-05 122325.png>)
![alt text](<Screenshot 2025-06-05 122338.png>)
![alt text](<Screenshot 2025-06-05 122349.png>)
![alt text](<Screenshot 2025-06-05 122402.png>)
![alt text](<Screenshot 2025-06-05 122712.png>)
![alt text](<Screenshot 2025-06-05 122721.png>)
![alt text](<Screenshot 2025-06-05 122732.png>)
![alt text](<Screenshot 2025-06-05 122743.png>)
![alt text](<Screenshot 2025-06-05 122755.png>)
![alt text](<Screenshot 2025-06-05 122807.png>)
![alt text](<Screenshot 2025-06-05 122852.png>)
![alt text](<Screenshot 2025-06-05 122941.png>)
![alt text](<Screenshot 2025-06-05 123923.png>)
![alt text](<Screenshot 2025-06-05 123932.png>)
![alt text](<Screenshot 2025-06-05 123939.png>)
![alt text](<Screenshot 2025-06-05 123951.png>)
![alt text](<Screenshot 2025-06-05 124003.png>)
![alt text](<Screenshot 2025-06-05 124015.png>)
![alt text](<Screenshot 2025-06-05 124058.png>)
![alt text](<Screenshot 2025-06-05 134021.png>)
![alt text](<Screenshot 2025-06-05 135259.png>)
