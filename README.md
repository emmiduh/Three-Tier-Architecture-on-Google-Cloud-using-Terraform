# ☁️ Three-Tier Architecture on Google Cloud using Terraform

This project provisions a **three-tier architecture** on Google Cloud using [Terraform](https://www.terraform.io/). It includes a **global HTTP load balancer**, **Managed Instance Groups (MIGs)** for the application tier, and **Cloud SQL** for the database tier, following a layered approach for resource provisioning and infrastructure as code best practices.

---

## 📌 Overview

This architecture consists of:

- **Load Balancer (Frontend)** – A global HTTP(S) load balancer to distribute traffic.
- **Application Tier (Middle)** – A Managed Instance Group (MIG) of Compute Engine virtual machines.
- **Database Tier (Backend)** – A Cloud SQL instance (MySQL/PostgreSQL) with credentials stored securely in **Secret Manager**.
- **Custom VPC** – With minimal subnets and secure firewall rules to control traffic.

> ⚠️ *This project uses HTTP for simplicity and provisions the Cloud SQL instance in a single zone with a public IP to reduce complexity and cost.*

---

## 🛠️ Technical Requirements

### ✅ Recommended

- **Fresh GCP Project** – Start with a new Google Cloud project for this deployment.
- **Terraform ≥ 1.0**
- **Google Cloud SDK (`gcloud`)**
- **Billing enabled** in your GCP project

### 🔐 Permissions (if using a Service Account)

- `Project IAM Admin`
- `Secret Manager Admin`
- `Compute Admin`
- `Cloud SQL Admin`

---

## 🌐 Architecture Diagram

```
          +-------------------------+
          |  Global Load Balancer  |
          +-----------+------------+
                      |
              Routes traffic (HTTP)
                      |
          +-----------v------------+
          | Managed Instance Group |
          |   (App Tier - VMs)     |
          +-----------+------------+
                      |
                      | Connects via Secret Manager
                      v
          +------------------------+
          |      Cloud SQL DB      |
          +------------------------+
```

---

## 📁 Directory Structure

Each **layer** is isolated into a subdirectory, and uses a separate Terraform state file. We use `terraform_remote_state` to expose outputs between layers.

```
/project-root
│
├── 01-vpc                # VPC, firewall rules, APIs
├── 02-database           # Cloud SQL instance, DB, DB user
├── 03-application        # MIG, Instance Template, Load Balancer
├── shared                # Reusable resources or variables
├── backend.tf            # Remote state config
└── README.md
```

---

## 🚀 Getting Started

1. **Clone the Repository**
   ```bash
   git clone https://github.com/emmiduh/three-tier-terraform-gcp.git
   cd three-tier-terraform-gcp
   ```

2. **Create Remote Backend Bucket**
   This must be done **manually**:
   ```bash
   export PROJECT_ID=<your-gcp-project-id>
   gsutil mb -p $PROJECT_ID -l us-central1 gs://$PROJECT_ID-tfstate
   ```

3. **Update `backend.tf` in each module** to point to the remote bucket:
   ```hcl
   bucket = "<your-project-id>-tfstate"
   ```

4. **Apply each layer in order**:
   ```bash
   cd 01-vpc
   terraform init
   terraform apply

   cd ../02-database
   terraform init
   terraform apply

   cd ../03-application
   terraform init
   terraform apply
   ```

---

## 🔄 Cleanup

To avoid incurring costs, always destroy the infrastructure when done:

```bash
cd 03-application
terraform destroy

cd ../02-database
terraform destroy

cd ../01-vpc
terraform destroy
```

---

## 📚 Resources

- [Terraform Documentation](https://developer.hashicorp.com/terraform/docs)
- [Google Cloud Terraform Provider](https://registry.terraform.io/providers/hashicorp/google/latest/docs)
- [Cloud SQL Best Practices](https://cloud.google.com/sql/docs/mysql/performance-best-practices)
- [Terraform for Google Cloud – Essential Guide (Packt)](https://github.com/PacktPublishing/Terraform-for-Google-Cloud-Essential-Guide)

---

## 📌 Notes

- The example uses **HTTP** instead of HTTPS for simplicity.
- The Cloud SQL instance uses a **public IP** and is in a **single zone**.
- The project assumes **Terraform modules are cleanly separated by layer**.

---

## 👥 Contributing

Pull requests are welcome! If you find a bug or want to suggest improvements, feel free to open an issue or submit a PR.

---

## 📄 License

This project is licensed under the MIT License.
