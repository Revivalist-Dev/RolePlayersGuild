<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="CharacterListing.ascx.cs" Inherits="RolePlayersGuild.templates.controls.CharacterListing" %>

<div runat="server" id="CharactListing" class="panel panel-primary">
    <div class="panel-heading">
        <h3 class="panel-title">
            <asp:Literal ID="litListingType" runat="server"></asp:Literal></h3>
    </div>

    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <div class="CharacterListing panel-body">
                <asp:Repeater ID="rptCharacters" runat="server" OnItemDataBound="rptCharacters_ItemDataBound">
                    <ItemTemplate>
                        <asp:Panel runat="server" ID="pnlCharacter" ClientIDMode="Predictable" itemscope itemtype="http://schema.org/CreativeWork">
                            <div itemprop="character" itemscope itemtype="http://schema.org/Person">
                                <a href="/Character?id=<%# Eval("CharacterID") %>" class="<%# Eval("CharacterNameClass") %>" title="<%# Eval("CharacterDisplayName") %>" itemprop="sameAs">
                                    <label itemprop="name"><%# Eval("CharacterDisplayName") %></label>
                                </a>
                                <a title="<%# Eval("CharacterDisplayName") %>" href="/Character/?id=<%# Eval("CharacterID") %>" class="thumbnail" style="background-image: url(<%# DisplayImageString(Eval("DisplayImageURL").ToString(), "thumb") %>);"></a>
                                <%# OnlineStatus(Eval("LastAction"), Eval("ShowWhenOnline")) %>
                            </div>
                        </asp:Panel>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>
    <asp:Panel runat="server" ID="pnlOtherOptions" class="panel-footer text-right small" Visible="false">
        <a href="/My-Characters/">My Characters</a>
        |
        <a href="/Character/Search/">View All Characters</a>
    </asp:Panel>
</div>

<%--<asp:SqlDataSource ID="sdsAllCharacters" runat="server" ConnectionString="<%$ ConnectionStrings:RolePlayersGuild.Properties.Settings.rpgDBConn %>" SelectCommand="SELECT DisplayImageURL, CharacterID, CharacterDisplayName FROM CharactersWithDisplayImages ORDER BY CharacterID DESC"></asp:SqlDataSource>--%>
<asp:SqlDataSource ID="sdsNewCharacters" runat="server" ConnectionString="<%$ ConnectionStrings:RolePlayersGuild.Properties.Settings.rpgDBConn %>" SelectCommand="SELECT TOP (@NumberOfRecordsToSelect) CharacterNameClass, DisplayImageURL, CharacterID, CharacterDisplayName, LastAction, ShowWhenOnline FROM CharactersForListing WHERE (UserID NOT IN (SELECT UserBlocked FROM User_Blocking WHERE (UserBlockedBy = @UserID)) AND UserID NOT IN (SELECT UserBlockedBy FROM User_Blocking AS User_Blocking WHERE (UserBlocked = @UserID))) ORDER BY CharacterID DESC">
    <SelectParameters>
        <asp:Parameter Name="NumberOfRecordsToSelect" Type="Int32" />
        <asp:SessionParameter Name="UserID" SessionField="UserID" Type="Int32" />
    </SelectParameters>
</asp:SqlDataSource>
<asp:SqlDataSource ID="sdsNewCharactersNoAuth" runat="server" ConnectionString="<%$ ConnectionStrings:RolePlayersGuild.Properties.Settings.rpgDBConn %>" SelectCommand="SELECT TOP (@NumberOfRecordsToSelect) CharacterNameClass, DisplayImageURL, CharacterID, CharacterDisplayName, LastAction, ShowWhenOnline FROM CharactersForListing ORDER BY CharacterID DESC">
    <SelectParameters>
        <asp:Parameter Name="NumberOfRecordsToSelect" Type="Int32" />
    </SelectParameters>
</asp:SqlDataSource>

<asp:SqlDataSource ID="sdsOnlineCharacters" runat="server" ConnectionString="<%$ ConnectionStrings:RolePlayersGuild.Properties.Settings.rpgDBConn %>" SelectCommand="Select Top (@NumberOfRecordsToSelect) * From RandomizedCharactersForListing Where (LastAction >= DateAdd(hour, -3, GetDate()) AND ShowWhenOnline = 1) AND (UserID NOT IN (SELECT UserBlocked FROM User_Blocking WHERE (UserBlockedBy = @UserID)) AND UserID NOT IN (SELECT UserBlockedBy FROM User_Blocking AS User_Blocking WHERE (UserBlocked = @UserID))) Order By NewID()">
    <SelectParameters>
        <asp:Parameter Name="NumberOfRecordsToSelect" Type="Int32" />
        <asp:SessionParameter Name="UserID" SessionField="UserID" Type="Int32" />
    </SelectParameters>
</asp:SqlDataSource>
<asp:SqlDataSource ID="sdsOnlineCharactersNoAuth" runat="server" ConnectionString="<%$ ConnectionStrings:RolePlayersGuild.Properties.Settings.rpgDBConn %>" SelectCommand="SELECT TOP (@NumberOfRecordsToSelect) * From RandomizedCharactersForListing WHERE (LastAction >= DateAdd(hour, -3, GetDate()) AND ShowWhenOnline = 1) Order By NewID()">
    <SelectParameters>
        <asp:Parameter Name="NumberOfRecordsToSelect" Type="Int32" />
    </SelectParameters>
</asp:SqlDataSource>
