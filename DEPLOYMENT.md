# Render & Neon Deployment Guide

This guide will help you deploy your Job Portal Django application on Render with Neon PostgreSQL database.

## Prerequisites
- GitHub account
- Render account (https://render.com)
- Your code pushed to GitHub

## Step 1: Push Code to GitHub

```bash
# Initialize git if not done (skip if already done)
git init

# Add all files
git add .

# Commit changes
git commit -m "Prepare Job Portal for Render and Neon deployment"

# Push to GitHub
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/hosting-job.git
git push -u origin main
```

## Step 2: Create Web Service on Render

1. Go to [Render Dashboard](https://dashboard.render.com)
2. Click **"New"** → **"Web Service"**
3. Connect your GitHub repository (hosting-job)
4. Fill in the following details:

   - **Name**: job-portal (or your preferred name)
   - **Environment**: Python
   - **Region**: Pick the closest region to your users
   - **Branch**: main
   - **Build Command**: 
     ```
     pip install -r requirements.txt && python manage.py collectstatic --noinput
     ```
   - **Start Command**: 
     ```
     gunicorn job_portal_django.wsgi:application --bind 0.0.0.0:$PORT
     ```

## Step 3: Set Environment Variables on Render

In the Render dashboard, go to your service and add these environment variables:

### Required Variables:

1. **SECRET_KEY** (Generate a new one for production)
   ```bash
   # Run this command locally to generate
   python -c "import secrets; print(secrets.token_urlsafe(50))"
   ```
   Copy the output and paste it as `SECRET_KEY` value

2. **ALLOWED_HOSTS**
   ```
   your-app-name.onrender.com
   ```
   (Replace `your-app-name` with your actual Render app name)

3. **DEBUG** (Must be False for production)
   ```
   False
   ```

4. **DATABASE_URL** (Your Neon connection string)
   ```
   postgresql://neondb_owner:npg_Z4gQiBJo3OME@ep-calm-river-a1pdn0qg-pooler.ap-southeast-1.aws.neon.tech/Job_database?sslmode=require&channel_binding=require
   ```

## Step 4: Deploy

1. In Render dashboard, click **"Create Web Service"**
2. Wait for the build to complete (this may take 2-3 minutes)
3. Once deployment is successful, your app will be live at:
   ```
   https://your-app-name.onrender.com
   ```

## Step 5: Run Migrations

After deployment, you need to run database migrations on your Neon database.

### Option A: Using Render's Shell (Recommended)

1. Go to your Render service dashboard
2. Click the **"Shell"** tab
3. Run the following commands:
   ```bash
   python manage.py migrate
   python manage.py createsuperuser
   python manage.py seed  # If you have a seed script
   ```

### Option B: Run Locally

Set the DATABASE_URL locally and run:
```bash
export DATABASE_URL="postgresql://neondb_owner:npg_Z4gQiBJo3OME@ep-calm-river-a1pdn0qg-pooler.ap-southeast-1.aws.neon.tech/Job_database?sslmode=require&channel_binding=require"
python manage.py migrate
python manage.py createsuperuser
```

## Step 6: Configure Your Domain (Optional)

If you want to use a custom domain:

1. In Render dashboard, go to your service settings
2. Under **"Custom Domain"**, add your domain
3. Update your domain provider's DNS records as instructed by Render

## Troubleshooting

### Build Fails
- Check build logs in Render dashboard
- Ensure all dependencies in `requirements.txt` are correct
- Verify Python version compatibility

### Database Connection Error
- Verify DATABASE_URL is correct in environment variables
- Check if Neon database allows connections from Render's IP
- Verify all special characters in password are properly encoded

### Static Files Not Loading
- Run `python manage.py collectstatic --noinput` locally to test
- Ensure WhiteNoise is installed and configured
- Clear browser cache

### Migrations Not Running
- Use Render Shell to run migrations manually
- Check migrations folder is in version control

## File Uploads (Media Files)

For production, consider using cloud storage for uploaded files:

1. **AWS S3** (Most common)
   - Install: `pip install django-storages boto3`
   - Configure in settings.py

2. **Cloudinary** (Easy setup)
   - Install: `pip install cloudinary django-cloudinary-storage`
   - Configure in settings.py

3. **Render Disk** (Not recommended for production)
   - Files are ephemeral and deleted on redeploy

## Monitoring

- Check logs in Render dashboard
- Set up alerts for failures
- Monitor performance metrics
- Use Django admin for database management

## Security Checklist

- [ ] SECRET_KEY is strong and unique
- [ ] DEBUG is set to False
- [ ] ALLOWED_HOSTS is correctly configured
- [ ] DATABASE_URL is secure and not exposed
- [ ] CSRF settings are enabled
- [ ] HTTPS is enforced (automatic on Render)
- [ ] Admin interface is protected

## Support

For issues with:
- **Render**: https://docs.render.com
- **Neon**: https://neon.tech/docs
- **Django**: https://docs.djangoproject.com
