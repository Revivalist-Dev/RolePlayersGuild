<%@ Page Title="My Characters on RPG" Language="C#" MasterPageFile="~/templates/2-Col With Authentication.master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="RolePlayersGuild.MyCharacters.Default" %>

<%@ MasterType VirtualPath="~/templates/2-Col With Authentication.master" %>
<%@ Register Src="~/templates/controls/UserNav.ascx" TagPrefix="uc1" TagName="UserNav" %>


<asp:Content ID="Content1" ContentPlaceHolderID="cphLeftCol" runat="server">
    <uc1:UserNav runat="server" ID="UserNav" />
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="cphRightCol" runat="server">
    <fieldset class="MyCharacterList">
        <legend>My Characters</legend>
        <div class="ButtonPanel clearfix">
            <ul>
                <li class="col-sm-4 col-xl-3">
                    <a href="/My-Writing/" class="btn btn-default">Back To My Writing</a>
                </li>
                <li class="col-sm-4 col-xl-3"></li>
                <li class="col-sm-4 col-xl-3 col-xl-offset-3"><a href="/My-Characters/Edit-Character?Mode=New" class="btn btn-success">
                    <span class="glyphicon glyphicon-plus"></span>
                    New Character</a></li>
            </ul>
        </div>
        <asp:ListView ID="lvCharacters" runat="server" GroupItemCount="3" DataSourceID="sdsCharacters">
            <LayoutTemplate>
                <div runat="server" id="groupPlaceholder">
                </div>
            </LayoutTemplate>
            <GroupTemplate>
                <%--<div class="row row-eq-height">--%>
                <div runat="server" id="itemPlaceholder"></div>
                <%--</div>--%>
            </GroupTemplate>
            <ItemTemplate>
                <div class="Item col-xl-2 col-lg-3 col-sm-4 col-xs-6">
                    <label><%# Eval("CharacterDisplayName") %></label>
                    <a href="/Character?id=<%# Eval("CharacterID") %>" class="Image thumbnail" style="background-image: url(<%# DisplayImageString(Eval("DisplayImageURL").ToString(), "thumb") %>)">
                        <%--<img class="lazyload" src="" data-src="<%# DisplayImageString(Eval("DisplayImageURL").ToString(), "full") %>" />--%>
                    </a>
                    <div class="ButtonPanel">
                        <ul>
                            <li class="col-sm-6"><a class="btn btn-default" href="/My-Characters/Edit-Character?Mode=Edit&CharID=<%# Eval("CharacterID") %>">
                                <span class="glyphicon glyphicon-edit"></span>
                                Edit</a></li>
                            <li class="col-sm-6"><a class="btn btn-default" href="/Character?id=<%# Eval("CharacterID") %>">
                                <span class="glyphicon glyphicon-eye-open"></span>
                                View</a>
                            </li>
                        </ul>
                    </div>
                </div>
            </ItemTemplate>
        </asp:ListView>
    </fieldset>

    <asp:SqlDataSource ID="sdsCharacters" runat="server" ConnectionString="<%$ ConnectionStrings:RolePlayersGuild.Properties.Settings.rpgDBConn %>" SelectCommand="SELECT [CharacterID], [CharacterDisplayName], [DisplayImageURL] FROM [CharactersWithDisplayImages] WHERE ([UserID] = @UserID)">
        <SelectParameters>
            <asp:SessionParameter Name="UserID" SessionField="UserID" Type="Int32" />
        </SelectParameters>
    </asp:SqlDataSource>
</asp:Content>
