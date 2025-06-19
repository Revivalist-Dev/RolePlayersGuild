-- This script will create the entire database schema required for the application to run.
-- WARNING: This will drop and re-create the 'rpgDB' database, deleting all existing data.

-- Step 1: Connect to the 'master' database to manage other databases.
USE master;
GO

-- Step 2: Drop the existing database if it exists to ensure a clean start.
IF DB_ID('rpgDB') IS NOT NULL
BEGIN
    ALTER DATABASE rpgDB SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE rpgDB;
END
GO

-- Step 3: Create a new, clean database.
CREATE DATABASE rpgDB;
GO

-- Step 4: Switch to the newly created database for all subsequent commands.
USE rpgDB;
GO

-- ====================================================================
-- Core Tables (without foreign keys to other complex tables yet)
-- ====================================================================

-- Step 5: Create the 'Users' table.
CREATE TABLE [dbo].[Users](
    [UserID] [int] IDENTITY(1,1) NOT NULL,
    [EmailAddress] [nvarchar](255) NULL,
    [Password] [nvarchar](255) NULL,
    [Username] [nvarchar](255) NULL,
    [LastAction] [datetime] NULL,
    [ShowWhenOnline] [bit] NOT NULL CONSTRAINT [DF_Users_ShowWhenOnline] DEFAULT ((1)),
    [IsAdmin] [bit] NOT NULL CONSTRAINT [DF_Users_IsAdmin] DEFAULT ((0)),
    [ReceiveAdminAnnouncements] [bit] NOT NULL CONSTRAINT [DF_Users_ReceiveAdminAnnouncements] DEFAULT ((1)),
    [LastHalloweenBadge] [datetime] NULL,
    [LastChristmasBadge] [datetime] NULL,
    [CurrentSendAsCharacter] [int] NOT NULL CONSTRAINT [DF_Users_CurrentSendAsCharacter] DEFAULT ((0)),
    [MembershipTypeID] [int] NOT NULL CONSTRAINT [DF_Users_MembershipTypeID] DEFAULT ((0)),
    [ShowWriterLinkOnCharacters] [bit] NOT NULL CONSTRAINT [DF_Users_ShowWriterLinkOnCharacters] DEFAULT ((1)),
    [LastLogin] [datetime] NULL,
    [UserTypeID] INT NOT NULL CONSTRAINT DF_Users_UserTypeID DEFAULT 1,
    [HideStream] BIT NOT NULL CONSTRAINT DF_Users_HideStream DEFAULT 0,
    [UseDarkTheme] BIT NOT NULL CONSTRAINT DF_Users_UseDarkTheme DEFAULT 0,
    [MemberJoinedDate] DATETIME NOT NULL CONSTRAINT DF_Users_MemberJoinedDate DEFAULT GETDATE(),
    CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED ([UserID] ASC)
);
GO

-- Step 5b: Create the 'Login_Attempts' table
CREATE TABLE [dbo].[Login_Attempts](
    [LoginAttemptID] [int] IDENTITY(1,1) NOT NULL,
    [IPAddress] [nvarchar](45) NOT NULL,
    [AttemptWasSuccessful] [bit] NOT NULL,
    [AttemptTimeStamp] [datetime] NOT NULL CONSTRAINT [DF_Login_Attempts_AttemptTimeStamp] DEFAULT (getdate()),
    [AttemptedUsername] [nvarchar](255) NULL,
    [AttemptedPassword] [nvarchar](255) NULL,
    CONSTRAINT [PK_Login_Attempts] PRIMARY KEY CLUSTERED ([LoginAttemptID] ASC)
);
GO

-- Step 5c: Create the 'Memberships' table
CREATE TABLE [dbo].[Memberships](
    [MembershipID] [int] IDENTITY(1,1) NOT NULL,
    [UserID] [int] NOT NULL,
    [MembershipTypeID] [int] NOT NULL,
    [StartDate] [datetime] NOT NULL,
    [EndDate] [datetime] NULL, -- Changed to NULLable to support subscriptions that don't have a fixed end date.
    [IsActive] [bit] NOT NULL,
    [PayPalSubscriptionID] [nvarchar](50) NULL,
    CONSTRAINT [PK_Memberships] PRIMARY KEY CLUSTERED ([MembershipID] ASC)
);
GO

-- Step 5d: Create the 'QuickLinks' table
CREATE TABLE [dbo].[QuickLinks](
    [QuickLinkID] [int] IDENTITY(1,1) NOT NULL,
    [UserID] [int] NOT NULL,
    [LinkName] [nvarchar](100) NOT NULL,
    [LinkAddress] [nvarchar](255) NOT NULL,
    [OrderNumber] [int] NOT NULL,
    CONSTRAINT [PK_QuickLinks] PRIMARY KEY CLUSTERED ([QuickLinkID] ASC)
);
GO

-- Step 5e: Create the 'User_Blocking' table
CREATE TABLE [dbo].[User_Blocking](
    [UserBlockID] [int] IDENTITY(1,1) NOT NULL,
    [UserBlocked] [int] NOT NULL,
    [UserBlockedBy] [int] NOT NULL,
    CONSTRAINT [PK_User_Blocking] PRIMARY KEY CLUSTERED ([UserBlockID] ASC)
);
GO

-- Step 5f: Create the 'Badges' table
CREATE TABLE [dbo].[Badges](
    [BadgeID] [int] IDENTITY(1,1) NOT NULL,
    [BadgeName] [nvarchar](100) NOT NULL,
    [BadgeDescription] [nvarchar](max) NULL,
    [BadgeImageURL] [nvarchar](255) NULL,
    [CharacterAssignable] [bit] NOT NULL CONSTRAINT DF_Badges_CharacterAssignable DEFAULT ((0)),
    CONSTRAINT [PK_Badges] PRIMARY KEY CLUSTERED ([BadgeID] ASC)
);
GO

SET IDENTITY_INSERT [dbo].[Badges] ON;
INSERT INTO [dbo].[Badges] (BadgeID, BadgeName, BadgeDescription, BadgeImageURL) VALUES
(1, 'Character Creator', 'Awarded for creating a character.', '/Images/Badges/CharacterCreated.png'),
(2, 'Article Creator', 'Awarded for writing an article.', '/Images/Badges/ArticleCreator.png'),
(3, 'Story Creator', 'Awarded for creating a story.', '/Images/Badges/StoryCreator.png'),
(4, 'Chat Room Creator', 'Awarded for creating a chat room.', '/Images/Badges/ChatRoomCreator.png'),
(5, 'Universe Creator', 'Awarded for creating a universe.', '/Images/Badges/UniverseCreator.png'),
(6, 'Bronze Member', 'Achieved Bronze Membership status.', '/Images/Badges/BronzeMember.png'),
(7, 'Silver Member', 'Achieved Silver Membership status.', '/Images/Badges/SilverMember.png'),
(8, 'Gold Member', 'Achieved Gold Membership status.', '/Images/Badges/GoldMember.png'),
(9, 'Platinum Member', 'Achieved Platinum Membership status.', '/Images/Badges/PlatinumMember.png'),
(10, 'Donor', 'Awarded for making a donation.', '/Images/Badges/Donor.png'),
(11, 'High Donor', 'Awarded for significant donations.', '/Images/Badges/HighDonor.png'),
(12, 'Friend Referral', 'Awarded for referring a friend.', '/Images/Badges/FriendReferral.png'),
(13, 'Mass Friend Referral', 'Awarded for referring multiple friends.', '/Images/Badges/MassFriendReferral.png'),
(14, 'Social Media Guru', 'Awarded for social media engagement.', '/Images/Badges/SocialMediaGuruBadge.png'),
(15, 'Staff Member', 'Awarded for being a staff member.', '/Images/Badges/StaffMember.png'),
(16, 'Master Creator', 'Awarded for creating various content types.', '/Images/Badges/MasterCreatorBadge.png'),
(17, 'RPG Gamer', 'Awarded for general gaming engagement.', '/Images/Badges/RPGGamer.png'),
(18, 'RPG Gamer Pro', 'Awarded for advanced gaming engagement.', '/Images/Badges/RPGGamerPro.png'),
(19, 'Finalist', 'Awarded for being a contest finalist.', '/Images/Badges/Finalist.png'),
(20, 'First Place', 'Awarded for winning a contest.', '/Images/Badges/FirstPlace.png'),
(24, 'Setting Creator', 'Awarded for creating a setting.', '/Images/Badges/Setting.png'),
(26, 'Cervical Cancer Awareness', 'Awarded for cervical cancer awareness event.', '/Images/Badges/CervicalCancerBadge.png'),
(27, 'Family Day', 'Awarded for participating in Family Day.', '/Images/Badges/FamilyDay.png'),
(28, 'Social Media Event', 'Awarded for participating in a social media event.', '/Images/Badges/SocialMediaEvent.png'),
(29, 'Tragedy Awareness', 'Awarded for tragedy awareness.', '/Images/Badges/TragedyBadge.png'),
(30, 'Unlimited Images', 'Awarded for unlimited image uploads.', '/Images/Badges/UnlimitedImages.png'),
(31, 'Unknown Badge', 'Placeholder for unknown badges.', '/Images/Badges/UnknownBadge.png'),
(34, 'Ten Year Member', 'Awarded for being a member for ten years.', '/Images/Badges/TenYearBadge.png'),
(35, 'Hadien Badge', 'Specific game/universe badge: Hadien.', '/Images/Badges/HadienBadge.png'),
(36, 'Hav Badge', 'Specific game/universe badge: Hav.', '/Images/Badges/HavBadge.png'),
(37, 'Eitorian Badge', 'Specific game/universe badge: Eitorian.', '/Images/Badges/EitorianBadge.png'),
(38, 'Ekiri Badge', 'Specific game/universe badge: Ekiri.', '/Images/Badges/EkiriBadge.png');
SET IDENTITY_INSERT [dbo].[Badges] OFF;
GO

-- Step 5g: Create the 'User_Badges' table
CREATE TABLE [dbo].[User_Badges](
    [UserBadgeID] [int] IDENTITY(1,1) NOT NULL,
    [UserID] [int] NOT NULL,
    [BadgeID] [int] NOT NULL,
    [AssignedToCharacterID] [int] NOT NULL CONSTRAINT DF_User_Badges_AssignedToCharacterID DEFAULT ((0)),
    [DateReceived] [datetime] NOT NULL CONSTRAINT DF_User_Badges_DateReceived DEFAULT (GETDATE()),
    CONSTRAINT [PK_User_Badges] PRIMARY KEY CLUSTERED ([UserBadgeID] ASC)
);
GO

-- Step 5h: Create the 'General_Settings' table
CREATE TABLE [dbo].[General_Settings](
    [SettingID] [int] IDENTITY(1,1) NOT NULL,
    [RPG2FundingGoal] [decimal](18, 2) NOT NULL CONSTRAINT [DF_General_Settings_RPG2FundingGoal] DEFAULT ((0.00)),
    [StreamSettingDescription] [nvarchar](max) NOT NULL CONSTRAINT [DF_General_Settings_StreamSettingDescription] DEFAULT (''),
    CONSTRAINT [PK_General_Settings] PRIMARY KEY CLUSTERED ([SettingID] ASC)
);
GO

IF NOT EXISTS (SELECT 1 FROM [dbo].[General_Settings])
BEGIN
    INSERT INTO [dbo].[General_Settings] ([RPG2FundingGoal], [StreamSettingDescription])
    VALUES (0.00, 'Default stream setting description.');
END
GO

-- Step 5i: Create the 'AdTypes' and 'Ads' tables
CREATE TABLE [dbo].[AdTypes](
    [AdTypeID] [int] IDENTITY(1,1) NOT NULL,
    [AdTypeName] [nvarchar](50) NOT NULL,
    CONSTRAINT [PK_AdTypes] PRIMARY KEY CLUSTERED ([AdTypeID] ASC)
);
GO

CREATE TABLE [dbo].[Ads](
    [AdID] [int] IDENTITY(1,1) NOT NULL,
    [AdTypeID] [int] NOT NULL,
    [AdName] [nvarchar](255) NOT NULL,
    [AdImageURL] [nvarchar](255) NOT NULL,
    [AdLink] [nvarchar](255) NOT NULL,
    [IsActive] [bit] NOT NULL CONSTRAINT [DF_Ads_IsActive] DEFAULT ((1)),
    CONSTRAINT [PK_Ads] PRIMARY KEY CLUSTERED ([AdID] ASC)
);
GO

-- Step 5j: Create the 'Categories' and 'Articles' tables
CREATE TABLE [dbo].[Categories](
    [CategoryID] [int] IDENTITY(1,1) NOT NULL,
    [CategoryName] [nvarchar](100) NOT NULL,
    CONSTRAINT [PK_Categories] PRIMARY KEY CLUSTERED ([CategoryID] ASC)
);
GO
INSERT INTO [dbo].[Categories] (CategoryName) VALUES ('Default');
GO

CREATE TABLE [dbo].[Articles](
    [ArticleID] [int] IDENTITY(1,1) NOT NULL,
    [OwnerUserID] [int] NOT NULL,
    -- CORRECTION: Made CategoryID nullable to match CreateNewArticle in DataFunctions.cs
    [CategoryID] [int] NULL,
    -- CORRECTION: Made ArticleTitle nullable to match CreateNewArticle in DataFunctions.cs
    [ArticleTitle] [nvarchar](255) NULL,
    -- CORRECTION: Made ArticleContent nullable to match CreateNewArticle in DataFunctions.cs
    [ArticleContent] [nvarchar](max) NULL,
    [DateSubmitted] [datetime] NOT NULL CONSTRAINT [DF_Articles_DateSubmitted] DEFAULT (getdate()),
    [CreatedDateTime] [datetime] NOT NULL CONSTRAINT [DF_Articles_CreatedDateTime] DEFAULT (getdate()),
    [IsPublished] [bit] NOT NULL CONSTRAINT [DF_Articles_IsPublished] DEFAULT ((0)),
    CONSTRAINT [PK_Articles] PRIMARY KEY CLUSTERED ([ArticleID] ASC)
);
GO

-- Step 5k: Create Chat_Rooms and Chat_Room_Posts tables
CREATE TABLE [dbo].[Chat_Rooms](
    [ChatRoomID] [int] IDENTITY(1,1) NOT NULL,
    [SubmittedByUserID] [int] NULL,
    [ChatRoomName] [nvarchar](255) NULL,
    [ContentRating] [nvarchar](50) NULL,
    [UniverseID] [int] NULL,
    CONSTRAINT [PK_Chat_Rooms] PRIMARY KEY CLUSTERED ([ChatRoomID] ASC)
);
GO

CREATE TABLE [dbo].[Chat_Room_Posts](
    [ChatPostID] [int] IDENTITY(1,1) NOT NULL,
    [ChatRoomID] [int] NOT NULL,
    [UserID] [int] NOT NULL,
    [PostContent] [nvarchar](max) NULL,
    [PostDateTime] [datetime] NOT NULL CONSTRAINT [DF_Chat_Room_Posts_PostDateTime] DEFAULT (getdate()),
    [CharacterID] [int] NULL,
    CONSTRAINT [PK_Chat_Room_Posts] PRIMARY KEY CLUSTERED ([ChatPostID] ASC)
);
GO

-- Step 5l: Create the 'Chat_Room_Locks' table
CREATE TABLE [dbo].[Chat_Room_Locks](
    [ChatRoomLockID] [int] IDENTITY(1,1) NOT NULL,
    [ChatRoomID] [int] NOT NULL,
    [UserID] [int] NOT NULL,
    CONSTRAINT [PK_Chat_Room_Locks] PRIMARY KEY CLUSTERED ([ChatRoomLockID] ASC)
);
GO

-- Step 5m: Create the 'ToDo_Items' table
CREATE TABLE [dbo].[ToDo_Items](
    [ItemID] [int] IDENTITY(1,1) NOT NULL,
    [AssignedToUserID] [int] NULL,
    [AssignedToCharacterID] [int] NULL,
    [StatusID] [int] NOT NULL CONSTRAINT [DF_ToDo_Items_StatusID] DEFAULT 1,
    [ItemDescription] [nvarchar](max) NULL,
    [CharacterAssignable] [bit] NOT NULL CONSTRAINT [DF_ToDo_Items_CharacterAssignable] DEFAULT 0,
    [DateReceived] [datetime] NOT NULL CONSTRAINT [DF_ToDo_Items_DateReceived] DEFAULT GETDATE(),
    CONSTRAINT [PK_ToDo_Items] PRIMARY KEY CLUSTERED ([ItemID] ASC)
);
GO

-- Step 5n: Create the 'Stories' table
CREATE TABLE [dbo].[Stories](
    [StoryID] [int] IDENTITY(1,1) NOT NULL,
    [UserID] [int] NOT NULL,
    -- CORRECTION: Made columns nullable to match CreateNewStory function in DataFunctions.cs
    [StoryTitle] [nvarchar](255) NULL,
    [StoryContent] [nvarchar](max) NULL,
    [StoryDescription] [nvarchar](max) NULL,
    [DateCreated] [datetime] NOT NULL CONSTRAINT [DF_Stories_DateCreated] DEFAULT (getdate()),
    [LastUpdated] [datetime] NULL,
    [RatingID] [int] NULL,
    [UniverseID] [int] NULL,
    CONSTRAINT [PK_Stories] PRIMARY KEY CLUSTERED ([StoryID] ASC)
);
GO

-- Step 5o: Create the 'Story_Posts' table
CREATE TABLE [dbo].[Story_Posts](
    [StoryPostID] [int] IDENTITY(1,1) NOT NULL,
    [StoryID] [int] NOT NULL,
    [UserID] [int] NOT NULL,
    [PostContent] [nvarchar](max) NULL,
    [PostDateTime] [datetime] NOT NULL CONSTRAINT [DF_Story_Posts_PostDateTime] DEFAULT (getdate()),
    CONSTRAINT [PK_Story_Posts] PRIMARY KEY CLUSTERED ([StoryPostID] ASC)
);
GO

-- Step 5p: Create Character_Image_Comments table
CREATE TABLE [dbo].[Character_Image_Comments](
    [ImageCommentID] [int] IDENTITY(1,1) NOT NULL,
    [ImageID] [int] NOT NULL,
    [UserID] [int] NOT NULL,
    [CommentContent] [nvarchar](max) NOT NULL,
    [CommentDateTime] [datetime] NOT NULL CONSTRAINT [DF_Character_Image_Comments_CommentDateTime] DEFAULT (GETDATE()),
    [IsRead] [bit] NOT NULL CONSTRAINT [DF_Character_Image_Comments_IsRead] DEFAULT ((0)),
    CONSTRAINT [PK_Character_Image_Comments] PRIMARY KEY CLUSTERED ([ImageCommentID] ASC)
);
GO

-- ====================================================================
-- Lookup Tables
-- ====================================================================

-- MembershipTypes
CREATE TABLE [dbo].[MembershipTypes](
    [MembershipTypeID] [int] IDENTITY(1,1) NOT NULL,
    [TypeName] [nvarchar](50) NOT NULL,
    [Description] [nvarchar](max) NULL,
    CONSTRAINT [PK_MembershipTypes] PRIMARY KEY CLUSTERED ([MembershipTypeID] ASC)
);
GO
SET IDENTITY_INSERT [dbo].[MembershipTypes] ON;
INSERT INTO [dbo].[MembershipTypes] (MembershipTypeID, TypeName, Description) VALUES
(0, 'Free', 'Standard free membership.'),
(1, 'Bronze', 'Bronze paid membership.'),
(2, 'Silver', 'Silver paid membership.'),
(3, 'Gold', 'Gold paid membership.'),
(4, 'Platinum', 'Platinum paid membership.');
SET IDENTITY_INSERT [dbo].[MembershipTypes] OFF;
GO

-- Character_Genders
CREATE TABLE [dbo].[Character_Genders](
    [GenderID] [int] IDENTITY(1,1) NOT NULL,
    [Gender] [nvarchar](50) NOT NULL,
    CONSTRAINT [PK_Character_Genders] PRIMARY KEY CLUSTERED ([GenderID] ASC)
);
GO
INSERT INTO [dbo].[Character_Genders] (Gender) VALUES ('Male'), ('Female'), ('Non-binary'), ('Agender'), ('Genderfluid'), ('Other'), ('Not Specified');
GO

-- Character_SexualOrientations
CREATE TABLE [dbo].[Character_SexualOrientations](
    [SexualOrientationID] [int] IDENTITY(1,1) NOT NULL,
    [SexualOrientation] [nvarchar](50) NOT NULL,
    CONSTRAINT [PK_Character_SexualOrientations] PRIMARY KEY CLUSTERED ([SexualOrientationID] ASC)
);
GO
INSERT INTO [dbo].[Character_SexualOrientations] (SexualOrientation) VALUES ('Heterosexual'), ('Homosexual'), ('Bisexual'), ('Pansexual'), ('Asexual'), ('Demisexual'), ('Other'), ('Not Specified');
GO

-- Genres
CREATE TABLE [dbo].[Genres](
    [GenreID] [int] IDENTITY(1,1) NOT NULL,
    [GenreName] [nvarchar](50) NOT NULL,
    CONSTRAINT [PK_Genres] PRIMARY KEY CLUSTERED ([GenreID] ASC)
);
GO
INSERT INTO [dbo].[Genres] (GenreName) VALUES ('Fantasy'), ('Sci-Fi'), ('Horror'), ('Modern'), ('Historical'), ('Fandom'), ('Post-Apocalyptic'), ('Steampunk'), ('Cyberpunk'), ('Slice of Life'), ('Mystery'), ('Adventure');
GO

-- Character_PostLengths
CREATE TABLE [dbo].[Character_PostLengths](
    [PostLengthID] [int] IDENTITY(1,1) NOT NULL,
    [PostLength] [nvarchar](50) NOT NULL,
    CONSTRAINT [PK_Character_PostLengths] PRIMARY KEY CLUSTERED ([PostLengthID] ASC)
);
GO
INSERT INTO [dbo].[Character_PostLengths] (PostLength) VALUES ('One-liners'), ('1-2 paragraphs'), ('3-5 paragraphs'), ('Multi-post'), ('Novella style');
GO

-- Character_LiteracyLevels
CREATE TABLE [dbo].[Character_LiteracyLevels](
    [LiteracyLevelID] [int] IDENTITY(1,1) NOT NULL,
    [LiteracyLevel] [nvarchar](50) NOT NULL,
    CONSTRAINT [PK_Character_LiteracyLevels] PRIMARY KEY CLUSTERED ([LiteracyLevelID] ASC)
);
GO
INSERT INTO [dbo].[Character_LiteracyLevels] (LiteracyLevel) VALUES ('Beginner'), ('Intermediate'), ('Advanced'), ('Literate'), ('Verbose'), ('Flexible');
GO

-- Character_LFRPStatuses
CREATE TABLE [dbo].[Character_LFRPStatuses](
    [LFRPStatusID] [int] IDENTITY(1,1) NOT NULL,
    [LFRPStatus] [nvarchar](50) NOT NULL,
    CONSTRAINT [PK_Character_LFRPStatuses] PRIMARY KEY CLUSTERED ([LFRPStatusID] ASC)
);
GO
INSERT INTO [dbo].[Character_LFRPStatuses] (LFRPStatus) VALUES ('Looking for RP'), ('Not looking for RP'), ('Maybe, ask me'), ('Open to anything');
GO

-- Character_EroticaPreferences
CREATE TABLE [dbo].[Character_EroticaPreferences](
    [EroticaPreferenceID] [int] IDENTITY(1,1) NOT NULL,
    [EroticaPreference] [nvarchar](50) NOT NULL,
    CONSTRAINT [PK_Character_EroticaPreferences] PRIMARY KEY CLUSTERED ([EroticaPreferenceID] ASC)
);
GO
INSERT INTO [dbo].[Character_EroticaPreferences] (EroticaPreference) VALUES ('None'), ('Fade to Black'), ('Yes'), ('Ask Me First');
GO

-- Character_Statuses
CREATE TABLE [dbo].[Character_Statuses](
    [CharacterStatusID] [int] IDENTITY(1,1) NOT NULL,
    [StatusName] [nvarchar](50) NOT NULL,
    CONSTRAINT [PK_Character_Statuses] PRIMARY KEY CLUSTERED ([CharacterStatusID] ASC)
);
GO
INSERT INTO [dbo].[Character_Statuses] (StatusName) VALUES ('Active'), ('Under Review'), ('Inactive'), ('Banned');
GO

-- Sources
CREATE TABLE [dbo].[Sources](
    [SourceID] [int] IDENTITY(1,1) NOT NULL,
    [Source] [nvarchar](50) NOT NULL,
    CONSTRAINT [PK_Sources] PRIMARY KEY CLUSTERED ([SourceID] ASC)
);
GO
SET IDENTITY_INSERT [dbo].[Sources] ON;
INSERT INTO [dbo].[Sources] (SourceID, Source) VALUES (1, 'Original'), (2, 'Fan-fiction'), (3, 'Game-based'), (4, 'Book-based'), (5, 'Movie/TV-based');
SET IDENTITY_INSERT [dbo].[Sources] OFF;
GO

-- Universe_Ratings
CREATE TABLE [dbo].[Universe_Ratings](
    [RatingID] [int] IDENTITY(1,1) NOT NULL,
    [RatingName] [nvarchar](50) NOT NULL,
    CONSTRAINT [PK_Universe_Ratings] PRIMARY KEY CLUSTERED ([RatingID] ASC)
);
GO
INSERT INTO [dbo].[Universe_Ratings] (RatingName) VALUES ('G'), ('PG'), ('PG-13'), ('R'), ('NC-17');
GO

-- Story_Ratings
CREATE TABLE [dbo].[Story_Ratings](
    [RatingID] [int] IDENTITY(1,1) NOT NULL,
    [RatingName] [nvarchar](50) NOT NULL,
    CONSTRAINT [PK_Story_Ratings] PRIMARY KEY CLUSTERED ([RatingID] ASC)
);
GO
INSERT INTO [dbo].[Story_Ratings] (RatingName) VALUES ('G'), ('PG'), ('PG-13'), ('R'), ('NC-17');
GO

-- Universes
CREATE TABLE [dbo].[Universes](
    [UniverseID] [int] IDENTITY(1,1) NOT NULL,
    [UniverseName] [nvarchar](255) NULL,
    [UniverseDescription] [nvarchar](max) NULL,
    [UniverseOwnerID] [int] NOT NULL,
    [SubmittedByID] [int] NULL,
    [CreatedDate] [datetime] NULL,
    [RatingID] [int] NULL,
    [SourceID] [int] NULL,
    [StatusID] [int] NULL,
    CONSTRAINT [PK_Universes] PRIMARY KEY CLUSTERED ([UniverseID] ASC)
);
GO

-- Character_Universes
CREATE TABLE [dbo].[Character_Universes](
    [CharacterUniverseID] [int] IDENTITY(1,1) NOT NULL,
    [CharacterID] [int] NOT NULL,
    [UniverseID] [int] NOT NULL,
    CONSTRAINT [PK_Character_Universes] PRIMARY KEY CLUSTERED ([CharacterUniverseID] ASC)
);
GO

-- ====================================================================
-- Characters Table and its Foreign Keys
-- ====================================================================
CREATE TABLE [dbo].[Characters](
    [CharacterID] [int] IDENTITY(1,1) NOT NULL,
    [UserID] [int] NULL,
    [CharacterDisplayName] [nvarchar](255) NULL,
    [CharacterFirstName] [nvarchar](255) NULL,
    [CharacterMiddleName] [nvarchar](255) NULL,
    [CharacterLastName] [nvarchar](255) NULL,
    [IsActive] [bit] NULL,
    [IsApproved] [bit] NULL,
    [CustomCSS] [nvarchar](max) NULL,
    [LastUpdated] [datetime] NULL,
    [DateSubmitted] [datetime] NULL,
    [SubmittedBy] [int] NULL,
    [IsPrivate] [bit] NOT NULL CONSTRAINT [DF_Characters_IsPrivate] DEFAULT ((0)),
    [Profile] [nvarchar](max) NULL,
    [LFRPStatus] INT NOT NULL CONSTRAINT DF_Characters_LFRPStatus DEFAULT 1,
    [DisableLinkify] BIT NOT NULL CONSTRAINT DF_Characters_DisableLinkify DEFAULT 0,
    [CharacterBio] [nvarchar](max) NULL,
    [CharacterGender] [int] NULL,
    [LiteracyLevel] [int] NULL,
    [PostLengthMax] [int] NULL,
    [PostLengthMin] [int] NULL,
    [MatureContent] [bit] NOT NULL CONSTRAINT [DF_Characters_MatureContent] DEFAULT 0,
    [SexualOrientation] [int] NULL,
    [EroticaPreferences] [int] NULL,
    [CharacterSourceID] [int] NULL,
    [CharacterStatusID] INT NOT NULL CONSTRAINT [DF_Characters_CharacterStatusID] DEFAULT 1,
    [TypeID] [int] NOT NULL CONSTRAINT [DF_Characters_TypeID] DEFAULT ((1)),
    [CustomProfileEnabled] [bit] NOT NULL CONSTRAINT [DF_Characters_CustomProfileEnabled] DEFAULT ((0)),
    [UniverseID] [int] NULL,
    CONSTRAINT [PK_Characters] PRIMARY KEY CLUSTERED ([CharacterID] ASC)
);
GO
ALTER TABLE [dbo].[Characters] WITH CHECK ADD CONSTRAINT [FK_Characters_Users] FOREIGN KEY([UserID]) REFERENCES [dbo].[Users] ([UserID]);
GO
ALTER TABLE [dbo].[Characters] CHECK CONSTRAINT [FK_Characters_Users];
GO
ALTER TABLE [dbo].[Characters] WITH CHECK ADD CONSTRAINT [FK_Characters_Character_Genders] FOREIGN KEY([CharacterGender]) REFERENCES [dbo].[Character_Genders] ([GenderID]);
GO
ALTER TABLE [dbo].[Characters] CHECK CONSTRAINT [FK_Characters_Character_Genders];
GO
ALTER TABLE [dbo].[Characters] WITH CHECK ADD CONSTRAINT [FK_Characters_Character_LiteracyLevels] FOREIGN KEY([LiteracyLevel]) REFERENCES [dbo].[Character_LiteracyLevels] ([LiteracyLevelID]);
GO
ALTER TABLE [dbo].[Characters] CHECK CONSTRAINT [FK_Characters_Character_LiteracyLevels];
GO
ALTER TABLE [dbo].[Characters] WITH CHECK ADD CONSTRAINT [FK_Characters_Character_PostLengths_Max] FOREIGN KEY([PostLengthMax]) REFERENCES [dbo].[Character_PostLengths] ([PostLengthID]);
GO
ALTER TABLE [dbo].[Characters] CHECK CONSTRAINT [FK_Characters_Character_PostLengths_Max];
GO
ALTER TABLE [dbo].[Characters] WITH CHECK ADD CONSTRAINT [FK_Characters_Character_PostLengths_Min] FOREIGN KEY([PostLengthMin]) REFERENCES [dbo].[Character_PostLengths] ([PostLengthID]);
GO
ALTER TABLE [dbo].[Characters] CHECK CONSTRAINT [FK_Characters_Character_PostLengths_Min];
GO
ALTER TABLE [dbo].[Characters] WITH CHECK ADD CONSTRAINT [FK_Characters_Character_SexualOrientations] FOREIGN KEY([SexualOrientation]) REFERENCES [dbo].[Character_SexualOrientations] ([SexualOrientationID]);
GO
ALTER TABLE [dbo].[Characters] CHECK CONSTRAINT [FK_Characters_Character_SexualOrientations];
GO
ALTER TABLE [dbo].[Characters] WITH CHECK ADD CONSTRAINT [FK_Characters_Character_EroticaPreferences] FOREIGN KEY([EroticaPreferences]) REFERENCES [dbo].[Character_EroticaPreferences] ([EroticaPreferenceID]);
GO
ALTER TABLE [dbo].[Characters] CHECK CONSTRAINT [FK_Characters_Character_EroticaPreferences];
GO
ALTER TABLE [dbo].[Characters] WITH CHECK ADD CONSTRAINT [FK_Characters_Character_LFRPStatuses] FOREIGN KEY([LFRPStatus]) REFERENCES [dbo].[Character_LFRPStatuses] ([LFRPStatusID]);
GO
ALTER TABLE [dbo].[Characters] CHECK CONSTRAINT [FK_Characters_Character_LFRPStatuses];
GO
ALTER TABLE [dbo].[Characters] WITH CHECK ADD CONSTRAINT [FK_Characters_Character_Statuses] FOREIGN KEY([CharacterStatusID]) REFERENCES [dbo].[Character_Statuses] ([CharacterStatusID]);
GO
ALTER TABLE [dbo].[Characters] CHECK CONSTRAINT [FK_Characters_Character_Statuses];
GO
ALTER TABLE [dbo].[Characters] WITH CHECK ADD CONSTRAINT [FK_Characters_Sources] FOREIGN KEY([CharacterSourceID]) REFERENCES [dbo].[Sources] ([SourceID]);
GO
ALTER TABLE [dbo].[Characters] CHECK CONSTRAINT [FK_Characters_Sources];
GO
ALTER TABLE [dbo].[Characters] WITH CHECK ADD CONSTRAINT [FK_Characters_Universes] FOREIGN KEY([UniverseID]) REFERENCES [dbo].[Universes] ([UniverseID]);
GO
ALTER TABLE [dbo].[Characters] CHECK CONSTRAINT [FK_Characters_Universes];
GO
ALTER TABLE [dbo].[ToDo_Items] WITH CHECK ADD CONSTRAINT [FK_ToDo_Items_Characters] FOREIGN KEY([AssignedToCharacterID]) REFERENCES [dbo].[Characters] ([CharacterID]);
GO
ALTER TABLE [dbo].[ToDo_Items] CHECK CONSTRAINT [FK_ToDo_Items_Characters];
GO

-- Character_Images table
CREATE TABLE [dbo].[Character_Images](
    [CharacterImageID] [int] IDENTITY(1,1) NOT NULL,
    [CharacterID] [int] NOT NULL,
    [CharacterImageURL] [nvarchar](255) NOT NULL,
    [IsPrimary] [bit] NOT NULL CONSTRAINT [DF_Character_Images_IsPrimary] DEFAULT ((0)),
    [IsMature] [bit] NOT NULL CONSTRAINT [DF_Character_Images_IsMature] DEFAULT ((0)),
    [ImageCaption] [nvarchar](500) NULL,
    CONSTRAINT [PK_Character_Images] PRIMARY KEY CLUSTERED ([CharacterImageID] ASC)
);
GO
ALTER TABLE [dbo].[Character_Images] WITH CHECK ADD CONSTRAINT [FK_Character_Images_Characters] FOREIGN KEY([CharacterID]) REFERENCES [dbo].[Characters] ([CharacterID]) ON DELETE CASCADE;
GO
ALTER TABLE [dbo].[Character_Images] CHECK CONSTRAINT [FK_Character_Images_Characters];
GO

-- Character_Genres table
CREATE TABLE [dbo].[Character_Genres](
    [CharacterGenreID] [int] IDENTITY(1,1) NOT NULL,
    [CharacterID] [int] NOT NULL,
    [GenreID] [int] NOT NULL,
    CONSTRAINT [PK_Character_Genres] PRIMARY KEY CLUSTERED ([CharacterGenreID] ASC)
);
GO
ALTER TABLE [dbo].[Character_Genres] WITH CHECK ADD CONSTRAINT [FK_Character_Genres_Characters] FOREIGN KEY([CharacterID]) REFERENCES [dbo].[Characters] ([CharacterID]) ON DELETE CASCADE;
GO
ALTER TABLE [dbo].[Character_Genres] CHECK CONSTRAINT [FK_Character_Genres_Characters];
GO
ALTER TABLE [dbo].[Character_Genres] WITH CHECK ADD CONSTRAINT [FK_Character_Genres_Genres] FOREIGN KEY([GenreID]) REFERENCES [dbo].[Genres] ([GenreID]) ON DELETE CASCADE;
GO
ALTER TABLE [dbo].[Character_Genres] CHECK CONSTRAINT [FK_Character_Genres_Genres];
GO

-- CORRECTION: Added missing Universe_Genres table referenced in DataFunctions.cs
CREATE TABLE [dbo].[Universe_Genres](
    [UniverseGenreID] [int] IDENTITY(1,1) NOT NULL,
    [UniverseID] [int] NOT NULL,
    [GenreID] [int] NOT NULL,
    CONSTRAINT [PK_Universe_Genres] PRIMARY KEY CLUSTERED ([UniverseGenreID] ASC)
);
GO
ALTER TABLE [dbo].[Universe_Genres] WITH CHECK ADD CONSTRAINT [FK_Universe_Genres_Universes] FOREIGN KEY([UniverseID]) REFERENCES [dbo].[Universes] ([UniverseID]) ON DELETE CASCADE;
GO
ALTER TABLE [dbo].[Universe_Genres] CHECK CONSTRAINT [FK_Universe_Genres_Universes];
GO
ALTER TABLE [dbo].[Universe_Genres] WITH CHECK ADD CONSTRAINT [FK_Universe_Genres_Genres] FOREIGN KEY([GenreID]) REFERENCES [dbo].[Genres] ([GenreID]) ON DELETE CASCADE;
GO
ALTER TABLE [dbo].[Universe_Genres] CHECK CONSTRAINT [FK_Universe_Genres_Genres];
GO


-- ====================================================================
-- Additional Tables & Foreign Keys
-- ====================================================================
ALTER TABLE [dbo].[Ads] WITH CHECK ADD CONSTRAINT [FK_Ads_AdTypes] FOREIGN KEY([AdTypeID]) REFERENCES [dbo].[AdTypes] ([AdTypeID]);
GO
ALTER TABLE [dbo].[Ads] CHECK CONSTRAINT [FK_Ads_AdTypes];
GO
ALTER TABLE [dbo].[Articles] WITH CHECK ADD CONSTRAINT [FK_Articles_Categories] FOREIGN KEY([CategoryID]) REFERENCES [dbo].[Categories] ([CategoryID]);
GO
ALTER TABLE [dbo].[Articles] CHECK CONSTRAINT [FK_Articles_Categories];
GO
ALTER TABLE [dbo].[Articles] WITH CHECK ADD CONSTRAINT [FK_Articles_Users] FOREIGN KEY([OwnerUserID]) REFERENCES [dbo].[Users] ([UserID]);
GO
ALTER TABLE [dbo].[Articles] CHECK CONSTRAINT [FK_Articles_Users];
GO

-- Chat_Room_Invites
CREATE TABLE [dbo].[Chat_Room_Invites](
    [InviteID] [int] IDENTITY(1,1) NOT NULL,
    [ChatRoomID] [int] NOT NULL,
    [UserID] [int] NOT NULL,
    CONSTRAINT [PK_Chat_Room_Invites] PRIMARY KEY CLUSTERED ([InviteID] ASC)
);
GO
ALTER TABLE [dbo].[Chat_Room_Invites] WITH CHECK ADD CONSTRAINT [FK_Chat_Room_Invites_Chat_Rooms] FOREIGN KEY([ChatRoomID]) REFERENCES [dbo].[Chat_Rooms] ([ChatRoomID]);
GO
ALTER TABLE [dbo].[Chat_Room_Invites] CHECK CONSTRAINT [FK_Chat_Room_Invites_Chat_Rooms];
GO
ALTER TABLE [dbo].[Chat_Room_Invites] WITH CHECK ADD CONSTRAINT [FK_Chat_Room_Invites_Users] FOREIGN KEY([UserID]) REFERENCES [dbo].[Users] ([UserID]);
GO
ALTER TABLE [dbo].[Chat_Room_Invites] CHECK CONSTRAINT [FK_Chat_Room_Invites_Users];
GO

-- Chat_Room_Locks
-- CORRECTION: Added ON DELETE CASCADE to simplify deletions.
ALTER TABLE [dbo].[Chat_Room_Locks] WITH CHECK ADD CONSTRAINT [FK_Chat_Room_Locks_Chat_Rooms] FOREIGN KEY([ChatRoomID]) REFERENCES [dbo].[Chat_Rooms] ([ChatRoomID]) ON DELETE CASCADE;
GO
ALTER TABLE [dbo].[Chat_Room_Locks] CHECK CONSTRAINT [FK_Chat_Room_Locks_Chat_Rooms];
GO
ALTER TABLE [dbo].[Chat_Room_Locks] WITH CHECK ADD CONSTRAINT [FK_Chat_Room_Locks_Users] FOREIGN KEY([UserID]) REFERENCES [dbo].[Users] ([UserID]);
GO
ALTER TABLE [dbo].[Chat_Room_Locks] CHECK CONSTRAINT [FK_Chat_Room_Locks_Users];
GO

-- Chat_Room_Posts
-- CORRECTION: Added ON DELETE CASCADE to simplify deletions.
ALTER TABLE [dbo].[Chat_Room_Posts] WITH CHECK ADD CONSTRAINT [FK_Chat_Room_Posts_Chat_Rooms] FOREIGN KEY([ChatRoomID]) REFERENCES [dbo].[Chat_Rooms] ([ChatRoomID]) ON DELETE CASCADE;
GO
ALTER TABLE [dbo].[Chat_Room_Posts] CHECK CONSTRAINT [FK_Chat_Room_Posts_Chat_Rooms];
GO
ALTER TABLE [dbo].[Chat_Room_Posts] WITH CHECK ADD CONSTRAINT [FK_Chat_Room_Posts_Users] FOREIGN KEY([UserID]) REFERENCES [dbo].[Users] ([UserID]);
GO
ALTER TABLE [dbo].[Chat_Room_Posts] CHECK CONSTRAINT [FK_Chat_Room_Posts_Users];
GO
ALTER TABLE [dbo].[Chat_Room_Posts] WITH CHECK ADD CONSTRAINT [FK_Chat_Room_Posts_Characters] FOREIGN KEY([CharacterID]) REFERENCES [dbo].[Characters] ([CharacterID]);
GO
ALTER TABLE [dbo].[Chat_Room_Posts] CHECK CONSTRAINT [FK_Chat_Room_Posts_Characters];
GO

-- Memberships
ALTER TABLE [dbo].[Memberships] WITH CHECK ADD CONSTRAINT [FK_Memberships_Users] FOREIGN KEY([UserID]) REFERENCES [dbo].[Users] ([UserID]);
GO
ALTER TABLE [dbo].[Memberships] CHECK CONSTRAINT [FK_Memberships_Users];
GO
ALTER TABLE [dbo].[Memberships] WITH CHECK ADD CONSTRAINT [FK_Memberships_MembershipTypes] FOREIGN KEY([MembershipTypeID]) REFERENCES [dbo].[MembershipTypes] ([MembershipTypeID]);
GO
ALTER TABLE [dbo].[Memberships] CHECK CONSTRAINT [FK_Memberships_MembershipTypes];
GO

-- QuickLinks
ALTER TABLE [dbo].[QuickLinks] WITH CHECK ADD CONSTRAINT [FK_QuickLinks_Users] FOREIGN KEY([UserID]) REFERENCES [dbo].[Users] ([UserID]);
GO
ALTER TABLE [dbo].[QuickLinks] CHECK CONSTRAINT [FK_QuickLinks_Users];
GO

-- Stories
ALTER TABLE [dbo].[Stories] WITH CHECK ADD CONSTRAINT [FK_Stories_Users] FOREIGN KEY([UserID]) REFERENCES [dbo].[Users] ([UserID]);
GO
ALTER TABLE [dbo].[Stories] CHECK CONSTRAINT [FK_Stories_Users];
GO
ALTER TABLE [dbo].[Stories] WITH CHECK ADD CONSTRAINT [FK_Stories_Story_Ratings] FOREIGN KEY([RatingID]) REFERENCES [dbo].[Story_Ratings] ([RatingID]);
GO
ALTER TABLE [dbo].[Stories] CHECK CONSTRAINT [FK_Stories_Story_Ratings];
GO
ALTER TABLE [dbo].[Stories] WITH CHECK ADD CONSTRAINT [FK_Stories_Universes] FOREIGN KEY([UniverseID]) REFERENCES [dbo].[Universes] ([UniverseID]);
GO
ALTER TABLE [dbo].[Stories] CHECK CONSTRAINT [FK_Stories_Universes];
GO

-- Story_Genres
CREATE TABLE [dbo].[Story_Genres](
    [StoryGenreID] [int] IDENTITY(1,1) NOT NULL,
    [StoryID] [int] NOT NULL,
    [GenreID] [int] NOT NULL,
    CONSTRAINT [PK_Story_Genres] PRIMARY KEY CLUSTERED ([StoryGenreID] ASC)
);
GO
ALTER TABLE [dbo].[Story_Genres] WITH CHECK ADD CONSTRAINT [FK_Story_Genres_Stories] FOREIGN KEY([StoryID]) REFERENCES [dbo].[Stories] ([StoryID]) ON DELETE CASCADE;
GO
ALTER TABLE [dbo].[Story_Genres] CHECK CONSTRAINT [FK_Story_Genres_Stories];
GO
ALTER TABLE [dbo].[Story_Genres] WITH CHECK ADD CONSTRAINT [FK_Story_Genres_Genres] FOREIGN KEY([GenreID]) REFERENCES [dbo].[Genres] ([GenreID]) ON DELETE CASCADE;
GO
ALTER TABLE [dbo].[Story_Genres] CHECK CONSTRAINT [FK_Story_Genres_Genres];
GO

-- Story_Posts
ALTER TABLE [dbo].[Story_Posts] WITH CHECK ADD CONSTRAINT [FK_Story_Posts_Stories] FOREIGN KEY([StoryID]) REFERENCES [dbo].[Stories] ([StoryID]);
GO
ALTER TABLE [dbo].[Story_Posts] CHECK CONSTRAINT [FK_Story_Posts_Stories];
GO
ALTER TABLE [dbo].[Story_Posts] WITH CHECK ADD CONSTRAINT [FK_Story_Posts_Users] FOREIGN KEY([UserID]) REFERENCES [dbo].[Users] ([UserID]);
GO
ALTER TABLE [dbo].[Story_Posts] CHECK CONSTRAINT [FK_Story_Posts_Users];
GO

-- Story_Views
CREATE TABLE [dbo].[Story_Views](
    [ViewID] [int] IDENTITY(1,1) NOT NULL,
    [StoryID] [int] NOT NULL,
    [UserID] [int] NOT NULL,
    [ViewDate] [datetime] NOT NULL,
    CONSTRAINT [PK_Story_Views] PRIMARY KEY CLUSTERED ([ViewID] ASC)
);
GO
ALTER TABLE [dbo].[Story_Views] WITH CHECK ADD CONSTRAINT [FK_Story_Views_Stories] FOREIGN KEY([StoryID]) REFERENCES [dbo].[Stories] ([StoryID]);
GO
ALTER TABLE [dbo].[Story_Views] CHECK CONSTRAINT [FK_Story_Views_Stories];
GO
ALTER TABLE [dbo].[Story_Views] WITH CHECK ADD CONSTRAINT [FK_Story_Views_Users] FOREIGN KEY([UserID]) REFERENCES [dbo].[Users] ([UserID]);
GO
ALTER TABLE [dbo].[Story_Views] CHECK CONSTRAINT [FK_Story_Views_Users];
GO

-- Threads
CREATE TABLE [dbo].[Threads](
    [ThreadID] [int] IDENTITY(1,1) NOT NULL,
    [ThreadTitle] [nvarchar](255) NOT NULL,
    [LastMessage] [datetime] NULL,
    -- CORRECTION: Made CreatedBy nullable to match CreateNewThread function which doesn't provide this value.
    [CreatedBy] [int] NULL,
    CONSTRAINT [PK_Threads] PRIMARY KEY CLUSTERED ([ThreadID] ASC)
);
GO
ALTER TABLE [dbo].[Threads] WITH CHECK ADD CONSTRAINT [FK_Threads_Users] FOREIGN KEY([CreatedBy]) REFERENCES [dbo].[Users] ([UserID]);
GO
ALTER TABLE [dbo].[Threads] CHECK CONSTRAINT [FK_Threads_Users];
GO

-- Thread_Messages
CREATE TABLE [dbo].[Thread_Messages](
    [ThreadMessageID] [int] IDENTITY(1,1) NOT NULL,
    [ThreadID] [int] NOT NULL,
    -- CORRECTION: This seems to be a CharacterID based on the DeleteCharacter method, not a UserID.
    [CreatorID] [int] NOT NULL,
    [MessageContent] [nvarchar](max) NOT NULL,
    -- CORRECTION: Added a default value as the InsertMessage method doesn't provide a timestamp.
    [TimeStamp] [datetime] NOT NULL CONSTRAINT [DF_Thread_Messages_TimeStamp] DEFAULT (getdate()),
    CONSTRAINT [PK_Thread_Messages] PRIMARY KEY CLUSTERED ([ThreadMessageID] ASC)
);
GO
ALTER TABLE [dbo].[Thread_Messages] WITH CHECK ADD CONSTRAINT [FK_Thread_Messages_Threads] FOREIGN KEY([ThreadID]) REFERENCES [dbo].[Threads] ([ThreadID]) ON DELETE CASCADE;
GO
ALTER TABLE [dbo].[Thread_Messages] CHECK CONSTRAINT [FK_Thread_Messages_Threads];
GO
-- CORRECTION: Changed FK to reference Characters instead of Users based on DeleteCharacter method logic.
ALTER TABLE [dbo].[Thread_Messages] WITH CHECK ADD CONSTRAINT [FK_Thread_Messages_Characters] FOREIGN KEY([CreatorID]) REFERENCES [dbo].[Characters] ([CharacterID]);
GO
ALTER TABLE [dbo].[Thread_Messages] CHECK CONSTRAINT [FK_Thread_Messages_Characters];
GO


-- Thread_Users
CREATE TABLE [dbo].[Thread_Users](
    [ThreadUserID] [int] IDENTITY(1,1) NOT NULL,
    [UserID] [int] NOT NULL,
    [ThreadID] [int] NOT NULL,
    [ReadStatusID] [int] NOT NULL CONSTRAINT [DF_Thread_Users_ReadStatusID] DEFAULT 2,
    [CharacterID] [int] NOT NULL,
    [PermissionID] [int] NOT NULL CONSTRAINT [DF_Thread_Users_PermissionID] DEFAULT 0,
    CONSTRAINT [PK_Thread_Users] PRIMARY KEY CLUSTERED ([ThreadUserID] ASC)
);
GO
ALTER TABLE [dbo].[Thread_Users] WITH CHECK ADD CONSTRAINT [FK_Thread_Users_Users] FOREIGN KEY([UserID]) REFERENCES [dbo].[Users] ([UserID]);
GO
ALTER TABLE [dbo].[Thread_Users] CHECK CONSTRAINT [FK_Thread_Users_Users];
GO
ALTER TABLE [dbo].[Thread_Users] WITH CHECK ADD CONSTRAINT [FK_Thread_Users_Threads] FOREIGN KEY([ThreadID]) REFERENCES [dbo].[Threads] ([ThreadID]) ON DELETE CASCADE;
GO
ALTER TABLE [dbo].[Thread_Users] CHECK CONSTRAINT [FK_Thread_Users_Threads];
GO
ALTER TABLE [dbo].[Thread_Users] WITH CHECK ADD CONSTRAINT [FK_Thread_Users_Characters] FOREIGN KEY([CharacterID]) REFERENCES [dbo].[Characters] ([CharacterID]);
GO
-- Note: No ON DELETE CASCADE here, as DeleteCharacter handles this manually in C#.
ALTER TABLE [dbo].[Thread_Users] CHECK CONSTRAINT [FK_Thread_Users_Characters];
GO


-- ToDo_Item_Votes
CREATE TABLE [dbo].[ToDo_Item_Votes](
    [ToDoItemVoteID] [int] IDENTITY(1,1) NOT NULL,
    [ToDoItemID] [int] NOT NULL,
    [UserID] [int] NOT NULL,
    CONSTRAINT [PK_ToDo_Item_Votes] PRIMARY KEY CLUSTERED ([ToDoItemVoteID] ASC)
);
GO
ALTER TABLE [dbo].[ToDo_Item_Votes] WITH CHECK ADD CONSTRAINT [FK_ToDo_Item_Votes_ToDo_Items] FOREIGN KEY([ToDoItemID]) REFERENCES [dbo].[ToDo_Items] ([ItemID]);
GO
ALTER TABLE [dbo].[ToDo_Item_Votes] CHECK CONSTRAINT [FK_ToDo_Item_Votes_ToDo_Items];
GO
ALTER TABLE [dbo].[ToDo_Item_Votes] WITH CHECK ADD CONSTRAINT [FK_ToDo_Item_Votes_Users] FOREIGN KEY([UserID]) REFERENCES [dbo].[Users] ([UserID]);
GO
ALTER TABLE [dbo].[ToDo_Item_Votes] CHECK CONSTRAINT [FK_ToDo_Item_Votes_Users];
GO

-- Universes foreign keys
ALTER TABLE [dbo].[Universes] WITH CHECK ADD CONSTRAINT [FK_Universes_Users] FOREIGN KEY([UniverseOwnerID]) REFERENCES [dbo].[Users] ([UserID]);
GO
ALTER TABLE [dbo].[Universes] CHECK CONSTRAINT [FK_Universes_Users];
GO
ALTER TABLE [dbo].[Universes] WITH CHECK ADD CONSTRAINT [FK_Universes_Universe_Ratings] FOREIGN KEY([RatingID]) REFERENCES [dbo].[Universe_Ratings] ([RatingID]);
GO
ALTER TABLE [dbo].[Universes] CHECK CONSTRAINT [FK_Universes_Universe_Ratings];
GO
ALTER TABLE [dbo].[Universes] WITH CHECK ADD CONSTRAINT [FK_Universes_Sources] FOREIGN KEY([SourceID]) REFERENCES [dbo].[Sources] ([SourceID]);
GO
ALTER TABLE [dbo].[Universes] CHECK CONSTRAINT [FK_Universes_Sources];
GO

-- CORRECTION: Add ON DELETE CASCADE to Chat_Rooms when a Universe is deleted.
ALTER TABLE [dbo].[Chat_Rooms] WITH CHECK ADD CONSTRAINT [FK_Chat_Rooms_Universes] FOREIGN KEY([UniverseID]) REFERENCES [dbo].[Universes] ([UniverseID]) ON DELETE CASCADE;
GO
ALTER TABLE [dbo].[Chat_Rooms] CHECK CONSTRAINT [FK_Chat_Rooms_Universes];
GO

-- Universe_Admins
CREATE TABLE [dbo].[Universe_Admins](
    [AdminID] [int] IDENTITY(1,1) NOT NULL,
    [UniverseID] [int] NOT NULL,
    [UserID] [int] NOT NULL,
    CONSTRAINT [PK_Universe_Admins] PRIMARY KEY CLUSTERED ([AdminID] ASC)
);
GO
ALTER TABLE [dbo].[Universe_Admins] WITH CHECK ADD CONSTRAINT [FK_Universe_Admins_Universes] FOREIGN KEY([UniverseID]) REFERENCES [dbo].[Universes] ([UniverseID]);
GO
ALTER TABLE [dbo].[Universe_Admins] CHECK CONSTRAINT [FK_Universe_Admins_Universes];
GO
ALTER TABLE [dbo].[Universe_Admins] WITH CHECK ADD CONSTRAINT [FK_Universe_Admins_Users] FOREIGN KEY([UserID]) REFERENCES [dbo].[Users] ([UserID]);
GO
ALTER TABLE [dbo].[Universe_Admins] CHECK CONSTRAINT [FK_Universe_Admins_Users];
GO

-- Universe_Bans
CREATE TABLE [dbo].[Universe_Bans](
    [BanID] [int] IDENTITY(1,1) NOT NULL,
    [UniverseID] [int] NOT NULL,
    [UserID] [int] NOT NULL,
    CONSTRAINT [PK_Universe_Bans] PRIMARY KEY CLUSTERED ([BanID] ASC)
);
GO
ALTER TABLE [dbo].[Universe_Bans] WITH CHECK ADD CONSTRAINT [FK_Universe_Bans_Universes] FOREIGN KEY([UniverseID]) REFERENCES [dbo].[Universes] ([UniverseID]);
GO
ALTER TABLE [dbo].[Universe_Bans] CHECK CONSTRAINT [FK_Universe_Bans_Universes];
GO
ALTER TABLE [dbo].[Universe_Bans] WITH CHECK ADD CONSTRAINT [FK_Universe_Bans_Users] FOREIGN KEY([UserID]) REFERENCES [dbo].[Users] ([UserID]);
GO
ALTER TABLE [dbo].[Universe_Bans] CHECK CONSTRAINT [FK_Universe_Bans_Users];
GO

-- Universe_Pending_Invites
CREATE TABLE [dbo].[Universe_Pending_Invites](
    [InviteID] [int] IDENTITY(1,1) NOT NULL,
    [UniverseID] [int] NOT NULL,
    [UserID] [int] NOT NULL,
    CONSTRAINT [PK_Universe_Pending_Invites] PRIMARY KEY CLUSTERED ([InviteID] ASC)
);
GO
ALTER TABLE [dbo].[Universe_Pending_Invites] WITH CHECK ADD CONSTRAINT [FK_Universe_Pending_Invites_Universes] FOREIGN KEY([UniverseID]) REFERENCES [dbo].[Universes] ([UniverseID]);
GO
ALTER TABLE [dbo].[Universe_Pending_Invites] CHECK CONSTRAINT [FK_Universe_Pending_Invites_Universes];
GO
ALTER TABLE [dbo].[Universe_Pending_Invites] WITH CHECK ADD CONSTRAINT [FK_Universe_Pending_Invites_Users] FOREIGN KEY([UserID]) REFERENCES [dbo].[Users] ([UserID]);
GO
ALTER TABLE [dbo].[Universe_Pending_Invites] CHECK CONSTRAINT [FK_Universe_Pending_Invites_Users];
GO

-- Character_Universes
ALTER TABLE [dbo].[Character_Universes] WITH CHECK ADD CONSTRAINT [FK_Character_Universes_Characters] FOREIGN KEY([CharacterID]) REFERENCES [dbo].[Characters] ([CharacterID]) ON DELETE CASCADE;
GO
ALTER TABLE [dbo].[Character_Universes] CHECK CONSTRAINT [FK_Character_Universes_Characters];
GO
ALTER TABLE [dbo].[Character_Universes] WITH CHECK ADD CONSTRAINT [FK_Character_Universes_Universes] FOREIGN KEY([UniverseID]) REFERENCES [dbo].[Universes] ([UniverseID]) ON DELETE CASCADE;
GO
ALTER TABLE [dbo].[Character_Universes] CHECK CONSTRAINT [FK_Character_Universes_Universes];
GO

-- User_Badges
ALTER TABLE [dbo].[User_Badges] WITH CHECK ADD CONSTRAINT [FK_User_Badges_Users] FOREIGN KEY([UserID]) REFERENCES [dbo].[Users] ([UserID]) ON DELETE CASCADE;
GO
ALTER TABLE [dbo].[User_Badges] CHECK CONSTRAINT [FK_User_Badges_Users];
GO
ALTER TABLE [dbo].[User_Badges] WITH CHECK ADD CONSTRAINT [FK_User_Badges_Badges] FOREIGN KEY([BadgeID]) REFERENCES [dbo].[Badges] ([BadgeID]);
GO
ALTER TABLE [dbo].[User_Badges] CHECK CONSTRAINT [FK_User_Badges_Badges];
GO

-- Character_Image_Comments
ALTER TABLE [dbo].[Character_Image_Comments] WITH CHECK ADD CONSTRAINT [FK_Character_Image_Comments_Character_Images] FOREIGN KEY([ImageID]) REFERENCES [dbo].[Character_Images] ([CharacterImageID]) ON DELETE CASCADE;
GO
ALTER TABLE [dbo].[Character_Image_Comments] CHECK CONSTRAINT [FK_Character_Image_Comments_Character_Images];
GO
ALTER TABLE [dbo].[Character_Image_Comments] WITH CHECK ADD CONSTRAINT [FK_Character_Image_Comments_Users] FOREIGN KEY([UserID]) REFERENCES [dbo].[Users] ([UserID]);
GO
ALTER TABLE [dbo].[Character_Image_Comments] CHECK CONSTRAINT [FK_Character_Image_Comments_Users];
GO

-- ====================================================================
-- Views
-- ====================================================================

-- 'CharactersForListing' view
CREATE VIEW [dbo].[CharactersForListing] AS
SELECT
    C.CharacterID, C.UserID, C.CharacterDisplayName, C.CharacterFirstName, C.CharacterMiddleName, C.CharacterLastName, C.IsActive, C.IsApproved, U.LastAction, U.ShowWhenOnline,
    CI.CharacterImageURL AS DisplayImageURL, CASE WHEN U.IsAdmin = 1 THEN 'AdminCharacter' ELSE 'NormalCharacter' END AS CharacterNameClass, C.TypeID, C.LFRPStatus
FROM dbo.Characters AS C
INNER JOIN dbo.Users AS U ON C.UserID = U.UserID
LEFT JOIN dbo.Character_Images AS CI ON C.CharacterID = CI.CharacterID AND CI.IsPrimary = 1;
GO

-- 'RandomizedCharactersForListing' view
CREATE VIEW [dbo].[RandomizedCharactersForListing] AS
SELECT TOP 100 PERCENT
    CharacterID, UserID, CharacterDisplayName, CharacterFirstName, CharacterMiddleName, CharacterLastName, IsActive, IsApproved, LastAction, ShowWhenOnline, DisplayImageURL, CharacterNameClass, TypeID, LFRPStatus
FROM dbo.CharactersForListing
ORDER BY NEWID();
GO

-- 'CharactersWithDetails' view
CREATE VIEW [dbo].[CharactersWithDetails] AS
SELECT
    C.CharacterID, C.UserID, C.CharacterDisplayName, C.CharacterFirstName, C.CharacterMiddleName, C.CharacterLastName, C.IsActive, C.IsApproved, C.CustomCSS, C.LastUpdated, C.DateSubmitted, C.SubmittedBy,
    C.IsPrivate, C.Profile, C.LFRPStatus, C.DisableLinkify, C.CharacterBio, C.CharacterGender, C.PostLengthMax, C.PostLengthMin, C.MatureContent, C.SexualOrientation, C.EroticaPreferences,
    C.CharacterSourceID, C.CharacterStatusID, C.TypeID, C.CustomProfileEnabled, U.Username, U.EmailAddress, U.LastAction, U.ShowWhenOnline, U.IsAdmin, U.ShowWriterLinkOnCharacters, U.LastLogin,
    G.Gender, LL.LiteracyLevel AS LiteracyLevelName, PLMax.PostLength AS PostLengthMaxDescription, PLMin.PostLength AS PostLengthMinDescription, SO.SexualOrientation AS CharacterSexualOrientation,
    EP.EroticaPreference, CS.StatusName AS CharacterStatus, LFRP.LFRPStatus AS LFRPStatusName, SRC.Source AS CharacterSource, CI.CharacterImageURL AS DisplayImageURL,
    C.LiteracyLevel as LiteracyLevelID, C.PostLengthMax AS PostLengthMaxID, C.PostLengthMin AS PostLengthMinID, UN.UniverseName AS UniverseName
FROM dbo.Characters AS C
INNER JOIN dbo.Users AS U ON C.UserID = U.UserID
LEFT JOIN dbo.Character_Genders AS G ON C.CharacterGender = G.GenderID
LEFT JOIN dbo.Character_LiteracyLevels AS LL ON C.LiteracyLevel = LL.LiteracyLevelID
LEFT JOIN dbo.Character_PostLengths AS PLMax ON C.PostLengthMax = PLMax.PostLengthID
LEFT JOIN dbo.Character_PostLengths AS PLMin ON C.PostLengthMin = PLMin.PostLengthID
LEFT JOIN dbo.Character_SexualOrientations AS SO ON C.SexualOrientation = SO.SexualOrientationID
LEFT JOIN dbo.Character_EroticaPreferences AS EP ON C.EroticaPreferences = EP.EroticaPreferenceID
LEFT JOIN dbo.Character_Images AS CI ON C.CharacterID = CI.CharacterID AND CI.IsPrimary = 1
LEFT JOIN dbo.Character_Statuses AS CS ON C.CharacterStatusID = CS.CharacterStatusID
LEFT JOIN dbo.Character_LFRPStatuses AS LFRP ON C.LFRPStatus = LFRP.LFRPStatusID
LEFT JOIN dbo.Sources AS SRC ON C.CharacterSourceID = SRC.SourceID
LEFT JOIN dbo.Universes AS UN ON C.UniverseID = UN.UniverseID;
GO

-- 'CharactersWithDisplayImages' view
CREATE VIEW [dbo].[CharactersWithDisplayImages] AS
SELECT
    C.CharacterID, C.UserID, C.CharacterDisplayName, C.CharacterFirstName, C.CharacterMiddleName, C.CharacterLastName, C.IsActive, C.IsApproved, C.CustomCSS, C.LastUpdated, C.DateSubmitted,
    C.SubmittedBy, C.IsPrivate, C.Profile, C.LFRPStatus, C.DisableLinkify, C.CharacterBio, C.CharacterGender, C.LiteracyLevel, C.PostLengthMax, C.PostLengthMin, C.MatureContent,
    C.SexualOrientation, C.EroticaPreferences, C.CharacterSourceID, C.TypeID, CI.CharacterImageURL AS DisplayImageURL, CI.IsPrimary, CI.IsMature
FROM dbo.Characters AS C
LEFT JOIN dbo.Character_Images AS CI ON C.CharacterID = CI.CharacterID AND CI.IsPrimary = 1;
GO

-- 'ArticlesForListing' view
CREATE VIEW [dbo].[ArticlesForListing] AS
SELECT
    A.ArticleID, A.ArticleTitle, A.DateSubmitted, A.CreatedDateTime, U.Username AS AuthorName, CAT.CategoryName, A.CategoryID, A.OwnerUserID
FROM dbo.Articles AS A
INNER JOIN dbo.Users AS U ON A.OwnerUserID = U.UserID
LEFT JOIN dbo.Categories AS CAT ON A.CategoryID = CAT.CategoryID
WHERE A.IsPublished = 1;
GO

-- 'Article_Categories' view
CREATE VIEW [dbo].[Article_Categories] AS
SELECT CategoryID, CategoryName
FROM dbo.Categories;
GO

-- 'ActiveChatrooms' view
CREATE VIEW [dbo].[ActiveChatrooms] AS
SELECT
    CR.ChatRoomID, CR.ChatRoomName, CR.SubmittedByUserID, CR.ContentRating, MAX(CRP.PostDateTime) AS LastPostTime
FROM dbo.Chat_Rooms AS CR
LEFT JOIN dbo.Chat_Room_Posts AS CRP ON CR.ChatRoomID = CRP.ChatRoomID
GROUP BY CR.ChatRoomID, CR.ChatRoomName, CR.SubmittedByUserID, CR.ContentRating;
GO

-- 'PopularStories' view
CREATE VIEW [dbo].[PopularStories] AS
SELECT
    S.StoryID, S.UserID, S.StoryTitle, S.StoryContent, MAX(SP.PostDateTime) AS LastPostDateTime, COUNT(SP.StoryPostID) AS PostCount
FROM dbo.Stories AS S
LEFT JOIN dbo.Story_Posts AS SP ON S.StoryID = SP.StoryID
GROUP BY S.StoryID, S.UserID, S.StoryTitle, S.StoryContent;
GO

-- 'ImageCommentsWithDetails' view
CREATE VIEW [dbo].[ImageCommentsWithDetails] AS
SELECT
    IC.ImageCommentID, IC.ImageID, IC.UserID AS CommenterUserID, U.Username AS CommenterUsername, IC.CommentContent, IC.CommentDateTime, IC.IsRead,
    CI.CharacterID AS ImageOwnerCharacterID, CH.UserID AS ImageOwnerUserID, CH.CharacterDisplayName AS ImageOwnerCharacterDisplayName, CI.CharacterImageURL, CI.IsMature AS ImageIsMature
FROM dbo.Character_Image_Comments AS IC
INNER JOIN dbo.Character_Images AS CI ON IC.ImageID = CI.CharacterImageID
INNER JOIN dbo.Characters AS CH ON CI.CharacterID = CH.CharacterID
INNER JOIN dbo.Users AS U ON IC.UserID = U.UserID;
GO

-- ======== NEWLY ADDED/CORRECTED VIEWS ========

-- View: ChatRoomsWithDetails
CREATE VIEW [dbo].[ChatRoomsWithDetails] AS
SELECT
    CR.ChatRoomID, CR.ChatRoomName, CR.SubmittedByUserID, CR.ContentRating, CR.UniverseID, U.Username AS SubmitterUsername, UN.UniverseName
FROM dbo.Chat_Rooms AS CR
LEFT JOIN dbo.Users AS U ON CR.SubmittedByUserID = U.UserID
LEFT JOIN dbo.Universes AS UN ON CR.UniverseID = UN.UniverseID;
GO

-- View: ArticlesWithDetails
CREATE VIEW [dbo].[ArticlesWithDetails] AS
SELECT
    A.ArticleID, A.OwnerUserID, A.CategoryID, A.ArticleTitle, A.ArticleContent, A.DateSubmitted, A.CreatedDateTime, A.IsPublished, U.Username AS AuthorUsername, C.CategoryName
FROM dbo.Articles AS A
INNER JOIN dbo.Users AS U ON A.OwnerUserID = U.UserID
LEFT JOIN dbo.Categories AS C ON A.CategoryID = C.CategoryID;
GO

-- View: StoriesWithDetails
CREATE VIEW [dbo].[StoriesWithDetails] AS
SELECT
    S.StoryID, S.UserID, S.StoryTitle, S.StoryContent, S.StoryDescription, S.DateCreated, S.LastUpdated, S.RatingID, S.UniverseID, U.Username AS AuthorUsername, SR.RatingName AS StoryRating, UN.UniverseName
FROM dbo.Stories AS S
INNER JOIN dbo.Users AS U ON S.UserID = U.UserID
LEFT JOIN dbo.Story_Ratings AS SR ON S.RatingID = SR.RatingID
LEFT JOIN dbo.Universes AS UN ON S.UniverseID = UN.UniverseID;
GO

-- View: UniversesWithDetails
CREATE VIEW [dbo].[UniversesWithDetails] AS
SELECT
    UV.UniverseID, UV.UniverseName, UV.UniverseDescription, UV.UniverseOwnerID, UV.CreatedDate, UV.RatingID, UV.SourceID, UV.StatusID, U.Username AS OwnerUsername, UR.RatingName AS UniverseRating, S.Source AS UniverseSource
FROM dbo.Universes AS UV
INNER JOIN dbo.Users AS U ON UV.UniverseOwnerID = U.UserID
LEFT JOIN dbo.Universe_Ratings AS UR ON UV.RatingID = UR.RatingID
LEFT JOIN dbo.Sources AS S ON UV.SourceID = S.SourceID;
GO

-- View: ThreadsWithDetails
CREATE VIEW [dbo].[ThreadsWithDetails] AS
SELECT
    T.ThreadID, T.ThreadTitle, T.LastMessage, T.CreatedBy AS CreatorUserID, TU.UserID, TU.ReadStatusID, TU.CharacterID, U.Username AS CreatorUsername
FROM dbo.Threads AS T
INNER JOIN dbo.Thread_Users AS TU ON T.ThreadID = TU.ThreadID
LEFT JOIN dbo.Users AS U ON T.CreatedBy = U.UserID;
GO

-- ====================================================================
-- Stored Procedures
-- ====================================================================

-- 'AwardNewBadgeIfNotAwarded' stored procedure
CREATE PROCEDURE [dbo].[AwardNewBadgeIfNotAwarded]
    @BADGE_ID INT,
    @USER_ID INT
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT EXISTS (SELECT 1 FROM [dbo].[User_Badges] WHERE UserID = @USER_ID AND BadgeID = @BADGE_ID)
    BEGIN
        INSERT INTO [dbo].[User_Badges] (UserID, BadgeID)
        VALUES (@USER_ID, @BADGE_ID);
    END
END
GO

PRINT 'Database rpgDB and all required tables/views have been created successfully.';