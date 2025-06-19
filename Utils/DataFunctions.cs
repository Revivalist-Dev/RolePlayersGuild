using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace RolePlayersGuild
{
    public class DataFunctions
    {
        public static int CurrentSendAsCharacterID
        {
            get
            {
                if (HttpContext.Current.Session["CurrentSendAsCharacter"] == null)
                {
                    if (CookieFunctions.UserID != 0)
                    {
                        int CharacterID = (int)Scalars.GetSingleValue("Select CurrentSendAsCharacter From Users Where UserID = @ParamOne", CookieFunctions.UserID);
                        HttpContext.Current.Session["CurrentSendAsCharacter"] = CharacterID;
                        return CharacterID;
                    }
                    return 0;
                }
                return ((int)HttpContext.Current.Session["CurrentSendAsCharacter"]);
            }
            set
            {
                Updates.UpdateRow("Update Users Set CurrentSendAsCharacter = @ParamTwo Where UserID = @ParamOne", CookieFunctions.UserID, value);
                HttpContext.Current.Session["CurrentSendAsCharacter"] = value;
            }
        }
        public static void AwardHolidayBadge(string BadgeType, int BadgeID, int UserID)
        {
            RunStatement("INSERT INTO User_Badges (UserID, BadgeID) VALUES (@ParamOne,@ParamTwo)", UserID, BadgeID);
            RunStatement("Update Users Set " + BadgeType + " = GetDate() Where UserID = @ParamOne", UserID);
        }
        public static void AwardBadgeIfNotExisting(int BadgeID, int UserID)
        {
            var scBadgeCommand = new SqlCommand("AwardNewBadgeIfNotAwarded", Connections.GetOpenRPGDBConn());
            scBadgeCommand.CommandType = CommandType.StoredProcedure;
            scBadgeCommand.Parameters.Add("@BADGE_ID", SqlDbType.Int).Value = BadgeID; 
            scBadgeCommand.Parameters.Add("@USER_ID", SqlDbType.Int).Value = UserID;
            scBadgeCommand.ExecuteNonQuery();
            scBadgeCommand.Connection.Close();
            scBadgeCommand.Dispose();
        }
        class Tools
        {
            public static int ProccessedInt(object ValueToProcess)
            {
                if (ValueToProcess != null)
                { return int.Parse(ValueToProcess.ToString()); }
                return 0;
            }
        }
        public static void RunStatement(string CommandString, object ParamOne = null,
                object ParamTwo = null, object ParamThree = null, object ParamFour = null, object ParamFive = null,
                 object ParamSix = null, object ParamSeven = null, object ParamEight = null, object ParamNine = null,
                  object ParamTen = null, object ParamEleven = null, object ParamTwelve = null, object ParamThirteen = null,
                  object ParamFourteen = null, object ParamFifteen = null, object ParamSixteen = null, object ParamSeventeen = null,
                  object ParamEighteen = null)
        {
            var scUpdateCommand = new SqlCommand(CommandString, Connections.GetOpenRPGDBConn());
            if (ParamOne != null) { scUpdateCommand.Parameters.AddWithValue("ParamOne", ParamOne); }
            if (ParamTwo != null) { scUpdateCommand.Parameters.AddWithValue("ParamTwo", ParamTwo); }
            if (ParamThree != null) { scUpdateCommand.Parameters.AddWithValue("ParamThree", ParamThree); }
            if (ParamFour != null) { scUpdateCommand.Parameters.AddWithValue("ParamFour", ParamFour); }
            if (ParamFive != null) { scUpdateCommand.Parameters.AddWithValue("ParamFive", ParamFive); }
            if (ParamSix != null) { scUpdateCommand.Parameters.AddWithValue("ParamSix", ParamSix); }
            if (ParamSeven != null) { scUpdateCommand.Parameters.AddWithValue("ParamSeven", ParamSeven); }
            if (ParamEight != null) { scUpdateCommand.Parameters.AddWithValue("ParamEight", ParamEight); }
            if (ParamNine != null) { scUpdateCommand.Parameters.AddWithValue("ParamNine", ParamNine); }
            if (ParamTen != null) { scUpdateCommand.Parameters.AddWithValue("ParamTen", ParamTen); }
            if (ParamEleven != null) { scUpdateCommand.Parameters.AddWithValue("ParamEleven", ParamEleven); }
            if (ParamTwelve != null) { scUpdateCommand.Parameters.AddWithValue("ParamTwelve", ParamTwelve); }
            if (ParamThirteen != null) { scUpdateCommand.Parameters.AddWithValue("ParamThirteen", ParamThirteen); }
            if (ParamFourteen != null) { scUpdateCommand.Parameters.AddWithValue("ParamFourteen", ParamFourteen); }
            if (ParamFifteen != null) { scUpdateCommand.Parameters.AddWithValue("ParamFifteen", ParamFifteen); }
            if (ParamSixteen != null) { scUpdateCommand.Parameters.AddWithValue("ParamSixteen", ParamSixteen); }
            if (ParamSeventeen != null) { scUpdateCommand.Parameters.AddWithValue("ParamSeventeen", ParamSeventeen); }
            if (ParamEighteen != null) { scUpdateCommand.Parameters.AddWithValue("ParamEighteen", ParamEighteen); }
            scUpdateCommand.ExecuteNonQuery();
            scUpdateCommand.Connection.Close();
            scUpdateCommand.Dispose();
        }
        public static void RunStatement(SqlConnection SQLConn, string CommandString, object ParamOne = null,
                object ParamTwo = null, object ParamThree = null, object ParamFour = null, object ParamFive = null,
                 object ParamSix = null, object ParamSeven = null, object ParamEight = null, object ParamNine = null,
                  object ParamTen = null, object ParamEleven = null, object ParamTwelve = null, object ParamThirteen = null,
                  object ParamFourteen = null, object ParamFifteen = null, object ParamSixteen = null, object ParamSeventeen = null,
                  object ParamEighteen = null)
        {
            var scUpdateCommand = new SqlCommand(CommandString, SQLConn);
            if (ParamOne != null) { scUpdateCommand.Parameters.AddWithValue("ParamOne", ParamOne); }
            if (ParamTwo != null) { scUpdateCommand.Parameters.AddWithValue("ParamTwo", ParamTwo); }
            if (ParamThree != null) { scUpdateCommand.Parameters.AddWithValue("ParamThree", ParamThree); }
            if (ParamFour != null) { scUpdateCommand.Parameters.AddWithValue("ParamFour", ParamFour); }
            if (ParamFive != null) { scUpdateCommand.Parameters.AddWithValue("ParamFive", ParamFive); }
            if (ParamSix != null) { scUpdateCommand.Parameters.AddWithValue("ParamSix", ParamSix); }
            if (ParamSeven != null) { scUpdateCommand.Parameters.AddWithValue("ParamSeven", ParamSeven); }
            if (ParamEight != null) { scUpdateCommand.Parameters.AddWithValue("ParamEight", ParamEight); }
            if (ParamNine != null) { scUpdateCommand.Parameters.AddWithValue("ParamNine", ParamNine); }
            if (ParamTen != null) { scUpdateCommand.Parameters.AddWithValue("ParamTen", ParamTen); }
            if (ParamEleven != null) { scUpdateCommand.Parameters.AddWithValue("ParamEleven", ParamEleven); }
            if (ParamTwelve != null) { scUpdateCommand.Parameters.AddWithValue("ParamTwelve", ParamTwelve); }
            if (ParamThirteen != null) { scUpdateCommand.Parameters.AddWithValue("ParamThirteen", ParamThirteen); }
            if (ParamFourteen != null) { scUpdateCommand.Parameters.AddWithValue("ParamFourteen", ParamFourteen); }
            if (ParamFifteen != null) { scUpdateCommand.Parameters.AddWithValue("ParamFifteen", ParamFifteen); }
            if (ParamSixteen != null) { scUpdateCommand.Parameters.AddWithValue("ParamSixteen", ParamSixteen); }
            if (ParamSeventeen != null) { scUpdateCommand.Parameters.AddWithValue("ParamSeventeen", ParamSeventeen); }
            if (ParamEighteen != null) { scUpdateCommand.Parameters.AddWithValue("ParamEighteen", ParamEighteen); }
            scUpdateCommand.ExecuteNonQuery();
            scUpdateCommand.Dispose();
        }

        public class Records
        {
            public static DataRow GetDataRow(string SelectString, int RowIndex, object ParamOne = null, object ParamTwo = null)
            {
                var da = new SqlDataAdapter(SelectString, Connections.GetOpenRPGDBConn());
                if (ParamOne != null) { da.SelectCommand.Parameters.AddWithValue("ParamOne", ParamOne); }
                if (ParamTwo != null) { da.SelectCommand.Parameters.AddWithValue("ParamTwo", ParamTwo); }
                var dt = new DataTable();
                da.Fill(dt);
                da.SelectCommand.Connection.Close();
                da.Dispose();
                if (dt.Rows.Count > 0)
                { return dt.Rows[RowIndex]; }
                return null;
            }
            public static DataRow GetUser(string EmailAddress, string Password)
            {
                return GetDataRow("Select * From Users Where EmailAddress = @ParamOne AND Password = @ParamTwo", 0, EmailAddress, Password);
            }
            public static DataRow GetChatRoom(int ChatRoomID)
            {
                return GetDataRow("Select * From Chat_Rooms Where ChatRoomID = @ParamOne", 0, ChatRoomID);
            }
            public static DataRow GetUniverse(int UniverseID)
            {
                return GetDataRow("Select * From Universes Where UniverseID = @ParamOne", 0, UniverseID);
            }
            public static DataRow GetUniverseWithDetails(int UniverseID)
            {
                return GetDataRow("Select * From UniversesWithDetails Where UniverseID = @ParamOne", 0, UniverseID);
            }
            public static DataRow GetChatRoomWithDetails(int ChatRoomID)
            {
                return GetDataRow("Select * From ChatRoomsWithDetails Where ChatRoomID = @ParamOne", 0, ChatRoomID);
            }
            public static DataRow GetArticleWithDetails(int ArticleID)
            {
                return GetDataRow("Select * From ArticlesWithDetails Where ArticleID = @ParamOne", 0, ArticleID);
            }
            public static DataRow GetStoryWithDetails(int StoryID)
            {
                return GetDataRow("Select * From StoriesWithDetails Where StoryID = @ParamOne", 0, StoryID);
            }
            public static DataRow GetRandomAd(int AdType)
            {
                return GetDataRow("Select * From Ads Where AdTypeID = @ParamOne Order By NewID()", 0, AdType);
            }

            public static DataRow GetUser(int UserID)
            {
                return GetDataRow("Select * From Users Where UserID = @ParamOne", 0, UserID);
            }
            public static DataRow GetCharacter(int CharacterID)
            {
                return GetDataRow("Select * From Characters Where CharacterID = @ParamOne", 0, CharacterID);
            }

            public static DataRow GetImage(int ImageID)
            {
                return GetDataRow("SELECT Character_Images.*, Characters.UserID FROM Character_Images INNER JOIN Characters On Character_Images.CharacterID = Characters.CharacterID WHERE (CharacterImageID = @ParamOne)", 0, ImageID);
            }

            public static DataRow GetDisplayImage(int CharacterID)
            {
                return GetDataRow("SELECT Character_Images.* FROM Character_Images INNER JOIN Characters ON Character_Images.CharacterID = Characters.CharacterID WHERE (Characters.CharacterID = @ParamOne) AND Character_Images.IsPrimary = 1;", 0, CharacterID);
            }

        }
        public class Connections
        {
            public static SqlConnection GetOpenRPGDBConn()
            {
                var con = new SqlConnection(ConfigurationManager.ConnectionStrings["RolePlayersGuild.Properties.Settings.rpgDBConn"].ToString());
                con.Open();
                return con;
            }
        }
        public class Inserts
        {
            public static object InsertRow(SqlCommand InsertCommand)
            {
                InsertCommand.Connection = Connections.GetOpenRPGDBConn();
                var ReturnObject = InsertCommand.ExecuteScalar();
                InsertCommand.Connection.Close();
                InsertCommand.Dispose();
                return ReturnObject;
            }
            public static object InsertRow(string InsertString, object ParamOne, object ParamTwo = null, object ParamThree = null, object ParamFour = null, object ParamFive = null, object ParamSix = null, object ParamSeven = null, object ParamEight = null, object ParamNine = null)
            {
                var scInsertCommand = new SqlCommand(InsertString, Connections.GetOpenRPGDBConn());
                scInsertCommand.Parameters.AddWithValue("ParamOne", ParamOne);
                if (ParamTwo != null) { scInsertCommand.Parameters.AddWithValue("ParamTwo", ParamTwo); }
                if (ParamThree != null) { scInsertCommand.Parameters.AddWithValue("ParamThree", ParamThree); }
                if (ParamFour != null) { scInsertCommand.Parameters.AddWithValue("ParamFour", ParamFour); }
                if (ParamFive != null) { scInsertCommand.Parameters.AddWithValue("ParamFive", ParamFive); }
                if (ParamSix != null) { scInsertCommand.Parameters.AddWithValue("ParamSix", ParamSix); }
                if (ParamSeven != null) { scInsertCommand.Parameters.AddWithValue("ParamSeven", ParamSeven); }
                if (ParamEight != null) { scInsertCommand.Parameters.AddWithValue("ParamEight", ParamEight); }
                if (ParamNine != null) { scInsertCommand.Parameters.AddWithValue("ParamNine", ParamNine); }
                var ReturnObject = scInsertCommand.ExecuteScalar();
                scInsertCommand.Connection.Close();
                scInsertCommand.Dispose();
                return ReturnObject;
            }
            public static object InsertRow(SqlConnection SqlConn, string InsertString, object ParamOne, object ParamTwo = null, object ParamThree = null, object ParamFour = null, object ParamFive = null)
            {
                var scInsertCommand = new SqlCommand(InsertString, SqlConn);
                scInsertCommand.Parameters.AddWithValue("ParamOne", ParamOne);
                if (ParamTwo != null) { scInsertCommand.Parameters.AddWithValue("ParamTwo", ParamTwo); }
                if (ParamThree != null) { scInsertCommand.Parameters.AddWithValue("ParamThree", ParamThree); }
                if (ParamFour != null) { scInsertCommand.Parameters.AddWithValue("ParamFour", ParamFour); }
                if (ParamFive != null) { scInsertCommand.Parameters.AddWithValue("ParamFive", ParamFive); }
                var ReturnObject = scInsertCommand.ExecuteScalar();
                scInsertCommand.Dispose();
                return ReturnObject;
            }

            public static string InsertThreadUserStatement { get { return "INSERT INTO Thread_Users (UserID, ThreadID, ReadStatusID, CharacterID, PermissionID) VALUES (@ParamOne, @ParamTwo, @ParamThree, @ParamFour, @ParamFive);"; } set { } }
            public static void InsertThreadUser(int UserID, int ThreadID, int ReadStatusID, int CharacterID, int PermissionID)
            {
                InsertRow(InsertThreadUserStatement, UserID, ThreadID, ReadStatusID, CharacterID, PermissionID);
            }
            public static void InsertThreadUser(SqlConnection SqlConn, int UserID, int ThreadID, int ReadStatusID, int CharacterID, int PermissionID)
            {
                InsertRow(SqlConn, InsertThreadUserStatement, UserID, ThreadID, ReadStatusID, CharacterID, PermissionID);
            }

            public static string InsertMessageStatement { get { return "INSERT INTO Thread_Messages(ThreadID, CreatorID, MessageContent) VALUES (@ParamOne, @ParamTwo, @ParamThree);"; } set { } }
            public static void InsertMessage(int ThreadID, int CreatorID, string MessageContent)
            {
                InsertRow(InsertMessageStatement, ThreadID, CreatorID, MessageContent);
            }
            public static void InsertMessage(SqlConnection SqlConn, int ThreadID, int CreatorID, string MessageContent)
            {
                InsertRow(SqlConn, InsertMessageStatement, ThreadID, CreatorID, MessageContent);
            }

            public static string NewThreadStatement { get { return "INSERT INTO Threads (ThreadTitle) VALUES (@ParamOne);Select Scope_Identity() as NewID;"; } set { } }
            public static int CreateNewThread(string ThreadTitle)
            {
                var ThreadID = InsertRow(NewThreadStatement, ThreadTitle);
                return Tools.ProccessedInt(ThreadID);
            }
            public static int CreateNewThread(SqlConnection SqlConn, string ThreadTitle)
            {
                var ThreadID = InsertRow(SqlConn, NewThreadStatement, ThreadTitle);
                return Tools.ProccessedInt(ThreadID);
            }

            public static int CreateNewUser(string EmailAddress, string Password, string Username)
            {
                var UserID = InsertRow("INSERT INTO Users (EmailAddress, Password, Username) VALUES (@ParamOne, @ParamTwo, @ParamThree);Select Scope_Identity() as NewID;",
                             EmailAddress, Password, Username);
                return Tools.ProccessedInt(UserID);
            }
            public static void BlockUser(int BlockerUserID, int BlockeeUserID)
            {
                InsertRow("INSERT INTO User_Blocking (UserBlocked, UserBlockedBy) VALUES (@ParamOne, @ParamTwo)",
                             BlockeeUserID, BlockerUserID);
            }
            public static int CreateNewCharacter(int UserID)
            {
                var CharacterID = InsertRow("INSERT INTO Characters (UserID) VALUES (@ParamOne);Select Scope_Identity() as NewID;", UserID);
                return Tools.ProccessedInt(CharacterID);
            }
            public static int CreateNewUniverse(int UserID)
            {
                var UniverseID = InsertRow("INSERT INTO Universes (UniverseOwnerID, SubmittedByID) VALUES (@ParamOne, @ParamOne);Select Scope_Identity() as NewID;", UserID);
                return Tools.ProccessedInt(UniverseID);
            }
            public static int CreateNewChatRoom(int UserID)
            {
                var ChatRoomID = InsertRow("INSERT INTO Chat_Rooms (SubmittedByUserID) VALUES (@ParamOne);Select Scope_Identity() as NewID;", UserID);
                return Tools.ProccessedInt(ChatRoomID);
            }
            public static int CreateNewArticle(int UserID)
            {
                var ArticleID = InsertRow("INSERT INTO Articles (OwnerUserID) VALUES (@ParamOne);Select Scope_Identity() as NewID;", UserID);
                return Tools.ProccessedInt(ArticleID);
            }
            public static int CreateNewStory(int UserID)
            {
                var StoryID = InsertRow("INSERT INTO Stories (UserID) VALUES (@ParamOne);Select Scope_Identity() as NewID;", UserID);
                return Tools.ProccessedInt(StoryID);
            }
            public static void AddImage(string ImageURL, int CharacterID, bool IsPrimary, bool IsMature, string ImageCaption)
            {
                InsertRow("INSERT INTO [Character_Images] ([CharacterImageURL], [CharacterID], [IsPrimary], [IsMature], [ImageCaption]) VALUES (@ParamOne, @ParamTwo, @ParamThree, @ParamFour, @ParamFive)",
                    ImageURL, CharacterID, IsPrimary, IsMature, ImageCaption);
            }
        }
        public class Deletes
        {
            public static void DeleteRows(string DeleteString, object ParamOne, object ParamTwo = null)
            {
                var scDeleteCommand = new SqlCommand(DeleteString, Connections.GetOpenRPGDBConn());
                scDeleteCommand.Parameters.AddWithValue("ParamOne", ParamOne);
                if (ParamTwo != null) { scDeleteCommand.Parameters.AddWithValue("ParamTwo", ParamTwo); }
                scDeleteCommand.ExecuteNonQuery();
                scDeleteCommand.Connection.Close();
                scDeleteCommand.Dispose();
            }
            public static void RemoveThreadCharacter(int CharacterID, int ThreadID)
            {
                DeleteRows("DELETE FROM Thread_Users WHERE (ThreadID = @ParamOne) AND (CharacterID = @ParamTwo)", ThreadID, CharacterID);
            }
            public static void RemoveThreadUser(int UserID, int ThreadID)
            {
                DeleteRows("DELETE FROM Thread_Users WHERE (ThreadID = @ParamOne) AND (UserID = @ParamTwo)", ThreadID, UserID);
            }
            public static void UnblockUser(int BlockRecordID)
            {
                DeleteRows("DELETE FROM User_Blocking WHERE (UserBlockID = @ParamOne)", BlockRecordID);
            }
            public static void NukeThread(int ThreadID)
            {
                DeleteRows("DELETE FROM [Threads] WHERE (([ThreadID] = @ParamOne)); Delete From [Thread_Messages] WHERE (([ThreadID] = @ParamOne)); Delete From [Thread_Users] WHERE (([ThreadID] = @ParamOne));", ThreadID);
            }
            public static void DeleteUniverse(int UniverseID)
            {
                SqlConnection con = Connections.GetOpenRPGDBConn();
                var scDeleteUniverse = new SqlCommand();
                scDeleteUniverse.Connection = con;

                scDeleteUniverse.CommandText = "DELETE FROM Universes Where UniverseID = @UniverseID;";
                scDeleteUniverse.CommandText += "DELETE FROM Character_Universes Where UniverseID = @UniverseID;";
                scDeleteUniverse.CommandText += "DELETE From Universe_Genres Where UniverseID = @UniverseID;";
                scDeleteUniverse.CommandText += "DELETE FROM Chat_Rooms Where UniverseID = @UniverseID;";
                scDeleteUniverse.Parameters.AddWithValue("UniverseID", UniverseID);

                scDeleteUniverse.ExecuteNonQuery();

                con.Close();
            }
            public static void DeleteChatRoom(int ChatRoomID)
            {
                SqlConnection con = Connections.GetOpenRPGDBConn();
                var scDeleteChat = new SqlCommand();
                scDeleteChat.Connection = con;

                scDeleteChat.CommandText = "DELETE FROM Chat_Rooms Where ChatRoomID = @ChatRoomID;";
                scDeleteChat.CommandText += "DELETE FROM Chat_Room_Posts Where ChatRoomID = @ChatRoomID;";
                scDeleteChat.CommandText += "DELETE FROM Chat_Room_Locks Where ChatRoomID = @ChatRoomID;";
                scDeleteChat.Parameters.AddWithValue("ChatRoomID", ChatRoomID);

                scDeleteChat.ExecuteNonQuery();

                con.Close();
            }
            public static void DeleteArticle(int ArticleID)
            {
                SqlConnection con = Connections.GetOpenRPGDBConn();
                var scDeleteArticle = new SqlCommand();
                scDeleteArticle.Connection = con;
                scDeleteArticle.CommandText = "DELETE FROM Articles Where ArticleID = @ArticleID;";
                scDeleteArticle.Parameters.AddWithValue("ArticleID", ArticleID);
                scDeleteArticle.ExecuteNonQuery();
                con.Close();
            }
            public static void DeleteStory(int StoryID)
            {
                SqlConnection con = Connections.GetOpenRPGDBConn();
                var scDeleteStory = new SqlCommand();
                scDeleteStory.Connection = con;
                scDeleteStory.CommandText = "DELETE FROM Stories Where StoryID = @StoryID;";
                scDeleteStory.Parameters.AddWithValue("StoryID", StoryID);
                scDeleteStory.ExecuteNonQuery();
                con.Close();
            }
            public static void DeleteCharacter(int CharacterID)
            {
                SqlConnection con = Connections.GetOpenRPGDBConn();
                var scGetCharacterImages = new SqlCommand("Select * From Character_Images Where CharacterID = @CharacterID", con);
                scGetCharacterImages.Parameters.AddWithValue("CharacterID", CharacterID);
                SqlDataReader drCharacterImages = scGetCharacterImages.ExecuteReader();

                if (drCharacterImages.HasRows)
                {
                    while (drCharacterImages.Read())
                    {
                        ImageFunctions.DeleteImage(drCharacterImages["CharacterImageURL"].ToString());
                    }
                }
                drCharacterImages.Close();

                var scDeleteCharacter = new SqlCommand();
                scDeleteCharacter.Connection = con;

                scDeleteCharacter.CommandText = "DELETE FROM Characters Where CharacterID = @CharacterID;";
                //scDeleteCharacter.CommandText += "DELETE FROM UpdateStream Where StreamPostMadeByCharacterID = @CharacterID;";
                scDeleteCharacter.CommandText += "DELETE FROM Thread_Users Where CharacterID = @CharacterID;";
                scDeleteCharacter.CommandText += "DELETE FROM Thread_Messages Where CreatorID = @CharacterID;";
                scDeleteCharacter.CommandText += "DELETE FROM Character_Images Where CharacterID = @CharacterID;";
                scDeleteCharacter.Parameters.AddWithValue("CharacterID", CharacterID);

                scDeleteCharacter.ExecuteNonQuery();

                con.Close();
            }
            public static void BanUser(int UserID)
            {

                //DataTable CharacterList = Tables.GetDataTable("Select CharacterID from Characters Where UserID = @ParamOne", UserID);

                //foreach (DataRow character in CharacterList.Rows)
                //{
                //    DeleteCharacter((int)character["CharacterID"]);
                //}
                RunStatement("UPDATE Users SET [Password] = 'UserBanned' + FORMAT(getdate(), 'yyyyMMddhhmmss'), Username = 'UserBanned' + FORMAT(getdate(), 'yyyyMMddhhmmss') WHERE (UserID = @ParamOne)", UserID);
            }
        }
        public class Scalars
        {
            public static object GetSingleValue(string SelectString, object ParamOne = null, object ParamTwo = null)
            {
                var scSelectValue = new SqlCommand(SelectString, Connections.GetOpenRPGDBConn());
                if (ParamOne != null) { scSelectValue.Parameters.AddWithValue("ParamOne", ParamOne); }
                if (ParamTwo != null) { scSelectValue.Parameters.AddWithValue("ParamTwo", ParamTwo); }
                var ReturnedObject = scSelectValue.ExecuteScalar();
                scSelectValue.Connection.Close();
                scSelectValue.Dispose();
                return ReturnedObject;
            }
            public static int GetUserID(int CharacterID)
            {
                var UserID = GetSingleValue("Select UserID From Characters Where CharacterID = @ParamOne", CharacterID);
                return Tools.ProccessedInt(UserID);
            }
            public static int GetUsedUpImageSlotCount(int UserID, int DefaultImageMax)
            {
                var UsedUpImageSlotCount = GetSingleValue("Select Count(CharacterImageID) - @ParamOne From Character_Images Where CharacterID In (Select ci2.CharacterID From Character_Images ci2 Group By ci2.CharacterID Having (Count(ci2.CharacterID) > (@ParamOne - 1))) AND CharacterID In (Select ch.CharacterID From Characters ch Where UserID = @ParamTwo)", DefaultImageMax, UserID);
                return Tools.ProccessedInt(UsedUpImageSlotCount);
            }
            public static int GetMembershipTypeID(int UserID)
            {
                var MembershipTypeID = GetSingleValue("Select Top 1 MembershipTypeID From Memberships Where UserID = @ParamOne And (EndDate is null Or EndDate > GetDate()) order by StartDate DESC", UserID);
                return Tools.ProccessedInt(MembershipTypeID);
            }
            public static int GetCharacterCount(int UserID)
            {
                var CharacterCount = GetSingleValue("Select Count(CharacterID) From Characters Where UserID = @ParamOne", UserID);
                return Tools.ProccessedInt(CharacterCount);
            }
            public static int GetUserID(string EmailAddress)
            {
                var UserID = GetSingleValue("Select UserID From Users Where EmailAddress = @ParamOne", EmailAddress);
                return Tools.ProccessedInt(UserID);
            }
            public static int GetUserIDByUsername(string Username)
            {
                var UserID = GetSingleValue("Select UserID From Users Where Username = @ParamOne", Username);
                return Tools.ProccessedInt(UserID);
            }
            public static int GetUserID(string EmailAddress, string Password)
            {
                var UserID = GetSingleValue("Select UserID From Users Where EmailAddress = @ParamOne AND Password = @ParamTwo", EmailAddress, Password);
                return Tools.ProccessedInt(UserID);
            }
            public static int GetBlockRecordID(int BlockeeUserID, int BlockerUserID)
            {
                var BlockRecordID = GetSingleValue("Select UserBlockID From User_Blocking Where UserBlocked = @ParamOne And UserBlockedBy = @ParamTwo", BlockeeUserID, BlockerUserID);
                return Tools.ProccessedInt(BlockRecordID);
            }
            public static int GetUnreadThreadCount(object UserID)
            {
                var UnreadThreadCount = GetSingleValue("SELECT COUNT(*) FROM Thread_Users WHERE (ReadStatusID = 2) AND (UserID = @ParamOne)", UserID);
                return Tools.ProccessedInt(UnreadThreadCount);
            }
            public static int GetUnreadImageCommentCountByUserID(object UserID)
            {
                var UnreadImageCommentCount = GetSingleValue("Select Count(ImageCommentID) From ImageCommentsWithDetails Where IsRead = 0 And ImageOwnerUserID = @ParamOne", UserID);
                return Tools.ProccessedInt(UnreadImageCommentCount);
            }
            public static int GetUnreadImageCommentCountByCharacterID(object CharacterID)
            {
                var UnreadImageCommentCount = GetSingleValue("Select Count(ImageCommentID) From ImageCommentsWithDetails Where IsRead = 0 And ImageOwnerCharacterID = @ParamOne", CharacterID);
                return Tools.ProccessedInt(UnreadImageCommentCount);
            }

            public static int GetMaxCharacterIdByUser(object UserID) {
                var CharacterID = GetSingleValue("Select Max(CharacterID) from Characters where UserID = @ParamOne", UserID);
                return Tools.ProccessedInt(CharacterID);
            }
        }
        public class Tables
        {
            public static DataTable GetDataTable(string SelectString, object ParamOne = null, object ParamTwo = null, object ParamThree = null)
            {
                var da = new SqlDataAdapter(SelectString, Connections.GetOpenRPGDBConn());
                if (ParamOne != null) { da.SelectCommand.Parameters.AddWithValue("ParamOne", ParamOne); }
                if (ParamTwo != null) { da.SelectCommand.Parameters.AddWithValue("ParamTwo", ParamTwo); }
                if (ParamThree != null) { da.SelectCommand.Parameters.AddWithValue("ParamThree", ParamThree); }
                var dt = new DataTable();
                da.Fill(dt);
                da.SelectCommand.Connection.Close();
                da.Dispose();
                return dt;
            }
            public static DataTable GetDataTable(SqlConnection SQLConn, string SelectString, object ParamOne = null, object ParamTwo = null)
            {
                var da = new SqlDataAdapter(SelectString, SQLConn);
                if (ParamOne != null) { da.SelectCommand.Parameters.AddWithValue("ParamOne", ParamOne); }
                if (ParamTwo != null) { da.SelectCommand.Parameters.AddWithValue("ParamTwo", ParamTwo); }
                var dt = new DataTable();
                da.Fill(dt);
                da.Dispose();
                return dt;
            }
            public static DataTable SearchUsers(string SearchValue, bool IncludeSelf)
            {
                int CharacterID = 0;
                string SelectQuery = "SELECT CharacterID, CASE WHEN ShowWhenOnline = 1 AND LastAction > DateAdd(hour, -3, GetDate()) THEN CharacterDisplayName + ' - <span class=''UserOnline inline''>Online</span>' ELSE CharacterDisplayName END As CharacterDisplayName FROM [CharactersForListing] WHERE (UserID NOT IN (SELECT UserBlocked FROM User_Blocking WHERE (UserBlockedBy = @ParamOne)) AND UserID NOT IN (SELECT UserBlockedBy FROM User_Blocking AS User_Blocking WHERE (UserBlocked = @ParamOne))) AND ";
                if (!IncludeSelf)
                { SelectQuery += "(UserID <> @ParamOne) AND "; }
                if (int.TryParse(SearchValue, out CharacterID))
                {
                    return GetDataTable(SelectQuery + "(CharacterID = @ParamTwo) ORDER BY CharacterDisplayName;", HttpContext.Current.Session["UserID"].ToString(), CharacterID);
                }
                else
                {
                    return GetDataTable(SelectQuery + "(CharacterDisplayName Like '%' + @ParamTwo + '%' OR CharacterFirstName Like '%' + @ParamTwo + '%' OR CharacterMiddleName Like '%' + @ParamTwo + '%' OR CharacterLastName Like '%' + @ParamTwo + '%') ORDER BY CharacterDisplayName;", HttpContext.Current.Session["UserID"].ToString(), SearchValue);
                }
            }
            public static DataTable SearchCharactersForThread(string SearchValue, int ThreadID)
            {
                int CharacterID = 0;
                string SelectQuery = "SELECT CharacterID, CASE WHEN ShowWhenOnline = 1 AND LastAction > DateAdd(hour, -3, GetDate()) THEN CharacterDisplayName + ' - <span class=''UserOnline inline''>Online</span>' ELSE CharacterDisplayName END As CharacterDisplayName FROM [CharactersWithDetails] WHERE CharacterID NOT IN (Select CharacterID From Thread_Users Where ThreadID = @ParamThree) AND (UserID NOT IN (SELECT UserBlocked FROM User_Blocking WHERE (UserBlockedBy = @ParamOne)) AND UserID NOT IN (SELECT UserBlockedBy FROM User_Blocking AS User_Blocking WHERE (UserBlocked = @ParamOne))) AND ";

                if (int.TryParse(SearchValue, out CharacterID))
                {
                    return GetDataTable(SelectQuery + "(CharacterID = @ParamTwo);", HttpContext.Current.Session["UserID"].ToString(), CharacterID, ThreadID);
                }
                else
                {
                    return GetDataTable(SelectQuery + "(CharacterDisplayName Like '%' + @ParamTwo + '%' OR CharacterFirstName Like '%' + @ParamTwo + '%' OR CharacterMiddleName Like '%' + @ParamTwo + '%' OR CharacterLastName Like '%' + @ParamTwo + '%') ORDER BY CharacterDisplayName;", HttpContext.Current.Session["UserID"].ToString(), SearchValue, ThreadID);
                }
            }
            public static DataTable GetThreadDetailsForUser(int ThreadID)
            {
                return GetDataTable("Select * From ThreadsWithDetails WHERE (UserID = @ParamOne) AND (ThreadID = @ParamTwo)", HttpContext.Current.Session["UserID"].ToString(), ThreadID);
            }
        }
        public class Updates
        {
            //
            public static void UpdateRow(string UpdateString, object ParamOne,
                 object ParamTwo = null, object ParamThree = null, object ParamFour = null, object ParamFive = null,
                  object ParamSix = null, object ParamSeven = null, object ParamEight = null, object ParamNine = null,
                   object ParamTen = null, object ParamEleven = null, object ParamTwelve = null, object ParamThirteen = null,
                   object ParamFourteen = null, object ParamFifteen = null, object ParamSixteen = null, object ParamSeventeen = null,
                   object ParamEighteen = null)
            {
                var scUpdateCommand = new SqlCommand(UpdateString, Connections.GetOpenRPGDBConn());
                scUpdateCommand.Parameters.AddWithValue("ParamOne", ParamOne);
                if (ParamTwo != null) { scUpdateCommand.Parameters.AddWithValue("ParamTwo", ParamTwo); }
                if (ParamThree != null) { scUpdateCommand.Parameters.AddWithValue("ParamThree", ParamThree); }
                if (ParamFour != null) { scUpdateCommand.Parameters.AddWithValue("ParamFour", ParamFour); }
                if (ParamFive != null) { scUpdateCommand.Parameters.AddWithValue("ParamFive", ParamFive); }
                if (ParamSix != null) { scUpdateCommand.Parameters.AddWithValue("ParamSix", ParamSix); }
                if (ParamSeven != null) { scUpdateCommand.Parameters.AddWithValue("ParamSeven", ParamSeven); }
                if (ParamEight != null) { scUpdateCommand.Parameters.AddWithValue("ParamEight", ParamEight); }
                if (ParamNine != null) { scUpdateCommand.Parameters.AddWithValue("ParamNine", ParamNine); }
                if (ParamTen != null) { scUpdateCommand.Parameters.AddWithValue("ParamTen", ParamTen); }
                if (ParamEleven != null) { scUpdateCommand.Parameters.AddWithValue("ParamEleven", ParamEleven); }
                if (ParamTwelve != null) { scUpdateCommand.Parameters.AddWithValue("ParamTwelve", ParamTwelve); }
                if (ParamThirteen != null) { scUpdateCommand.Parameters.AddWithValue("ParamThirteen", ParamThirteen); }
                if (ParamFourteen != null) { scUpdateCommand.Parameters.AddWithValue("ParamFourteen", ParamFourteen); }
                if (ParamFifteen != null) { scUpdateCommand.Parameters.AddWithValue("ParamFifteen", ParamFifteen); }
                if (ParamSixteen != null) { scUpdateCommand.Parameters.AddWithValue("ParamSixteen", ParamSixteen); }
                if (ParamSeventeen != null) { scUpdateCommand.Parameters.AddWithValue("ParamSeventeen", ParamSeventeen); }
                if (ParamEighteen != null) { scUpdateCommand.Parameters.AddWithValue("ParamEighteen", ParamEighteen); }
                scUpdateCommand.ExecuteNonQuery();
                scUpdateCommand.Connection.Close();
                scUpdateCommand.Dispose();
            }
            public static void MarkUnreadForOthersOnThread(int ThreadID)
            {
                UpdateRow("UPDATE Thread_Users SET ReadStatusID = @ParamOne WHERE (ThreadID = @ParamTwo) AND (UserID <> @ParamThree)", "2", ThreadID, HttpContext.Current.Session["UserID"].ToString());
            }
            public static void MarkReadForCurrentUser(int ThreadID)
            {
                UpdateRow("UPDATE Thread_Users SET ReadStatusID = @ParamOne WHERE (ThreadID = @ParamTwo) AND (UserID = @ParamThree)", "1", ThreadID, HttpContext.Current.Session["UserID"].ToString());
            }
            public static void ChangeReadStatusForCurrentUser(int ThreadID, int ReadStatus)
            {
                UpdateRow("UPDATE Thread_Users SET ReadStatusID = @ParamOne WHERE (ThreadID = @ParamTwo) AND (UserID = @ParamThree)", ReadStatus, ThreadID, HttpContext.Current.Session["UserID"].ToString());
            }

            public static void RemoveDefaultFlagFromImages(int GalleryID)
            {
                UpdateRow("UPDATE Character_Images SET IsPrimary = 0 WHERE (CharacterID = @ParamOne)", GalleryID);
            }
            public static void UpdateImage(int ImageID, bool IsPrimary, bool IsMature, string ImageCaption)
            {
                UpdateRow("UPDATE Character_Images SET IsPrimary = @ParamTwo, IsMature = @ParamThree, ImageCaption = @ParamFour WHERE (CharacterImageID = @ParamOne)", ImageID, IsPrimary, IsMature, ImageCaption);
            }

        }
    }
}