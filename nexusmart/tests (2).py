from django.test import TestCase
from api.category.models import Category
import requests


class APITestCase(TestCase):
    def test_auth_api(self):
        # Use Django's built-in test client for internal API endpoint testing
        response = self.client.get("/api/")
        self.assertEqual(response.status_code, 200)
        self.assertIn(b"Welcome to the REST-API for NexusMart E-Commerce", response.content)


class ModelsTestCase(TestCase):
    def test_category_model(self):
        """Categories are stored and retrieved successfully"""
        cate = Category.objects.create(category_name="Electronics", category_slug="electronics")
        cate.save()
        self.assertEqual(cate.category_name, "Electronics")
