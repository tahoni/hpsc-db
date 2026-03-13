# Release History & Documentation

Versioned release notes and release-history references for the HPSC Database.

## 📌 Table of Contents

- [📌 Overview](#-overview)
- [📚 Available Versions](#-available-versions)
- [📊 Version Summary](#-version-summary)
- [⚠️ Breaking Changes Overview](#-breaking-changes-overview)
- [🔗 Related Documentation](#-related-documentation)
- [📝 Document Metadata](#-document-metadata)

## 📌 Overview

This directory stores version-specific release notes.
Use `../../RELEASE_NOTES.md` for the latest consolidated release notes and `../../HISTORY.md` for narrative
release context.

## 📚 Available Versions

- **[v3.0.0](./RELEASE_NOTES_v3.0.0.md)** - Schema Maintenance & Migration Reliability (Mar 13, 2026) - *
  *Stable**
- **[v2.0.1](./RELEASE_NOTES_v2.0.1.md)** – Documentation & Release Hygiene (Feb 25, 2026) – **Archived**
- **[v2.0.0](./RELEASE_NOTES_v2.0.0.md)** - Schema Refinement & Data Integrity (Feb 23, 2026) - **Archived**
- **[v1.1.0](./RELEASE_NOTES_v1.1.0.md)** – Enhanced Schema & Documentation (Jan 28, 2026) – **Archived**
- **[v1.0.0](./RELEASE_NOTES_v1.0.0.md)** – Initial Release (Dec 28, 2025) – **Archived**

## 📊 Version Summary

| Version   | Date         | Theme                                      | Status   | Breaking Changes |
|-----------|--------------|--------------------------------------------|----------|------------------|
| **3.0.0** | Mar 13, 2026 | Schema Maintenance & Migration Reliability | Stable   | ⚠️ Yes           |
| **2.0.1** | Feb 25, 2026 | Documentation & Release Hygiene            | Archived | ✅ No             |
| **2.0.0** | Feb 23, 2026 | Schema Refinement & Data Integrity         | Archived | ⚠️ Yes           |
| **1.1.0** | Jan 28, 2026 | Enhanced Schema & Documentation            | Archived | ✅ No             |
| **1.0.0** | Dec 28, 2025 | Initial Release                            | Archived | N/A              |

## ⚠️ Breaking Changes Overview

- **v3.0.0** - `ipsc_match.name` is no longer globally unique
- **v2.0.0** – Removed redundant `club` columns and enforced `club_id` joins

## 🔗 Related Documentation

- [Release Notes History](./RELEASE_NOTES_HISTORY.md)
- [Consolidated Release Notes](../../RELEASE_NOTES.md)
- [Project History](../../HISTORY.md)
- [Changelog](../../CHANGELOG.md)
- [Archive Reference](../archive/ARCHIVE.md)

## 📝 Document Metadata

- **Created:** February 24, 2026
- **Last Updated:** March 13, 2026
- **Coverage:** v1.0.0 – v3.0.0 (5 releases)
- **Total Files:** 7 documentation files

